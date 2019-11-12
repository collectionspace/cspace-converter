class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, type, batch_name, key)
    action_method = TransferJob.actions action
    raise "Invalid remote action #{action}!" unless action_method

    batch = Batch.retrieve(key)
    batch.status = 'running' # reset running status
    batch.save

    CollectionSpaceObject.batch_size(
      ENV.fetch('CSPACE_CONVERTER_TRANSFER_BATCH_SIZE', 25)
    ).where(type: type, batch: batch_name).each do |object|
      begin
        service = RemoteActionService.new(object)
        if !object.is_relationship? && !object.has_csid_and_uri?
          service.remote_ping # update csid and uri if object is found
        end
        status = service.send(action_method)
        status.ok ? batch.processed += 1 : batch.failed += 1
      rescue StandardError
        batch.failed += 1
      end
    end
    batch.status = 'complete'
    batch.end = Time.now
    batch.save
  end

  def self.actions(action)
    {
      "delete" => :remote_delete,
      "remote_delete" => :remote_delete,
      "transfer" => :remote_transfer,
      "remote_transfer" => :remote_transfer,
      "update" => :remote_update,
      "remote_update" => :remote_update,
    }[action]
  end
end
