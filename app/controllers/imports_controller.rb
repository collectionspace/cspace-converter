class ImportsController < ApplicationController

  def new
    # form
  end

  def create
    file = params[:file]

    if file.respond_to? :path
      config = {
        file: file.path,
        key: SecureRandom.uuid,
        batch: params[:batch],
        module: params[:module],
        profile: params[:profile],
      }

      Batch.create(
        key: config[:key],
        category: 'import',
        type: Lookup.converter_class,
        for: config[:profile],
        name: config[:batch],
        start: Time.now
      )

      ::SmarterCSV.process(file.path, {
          chunk_size: 100,
          convert_values_to_numeric: false,
        }.merge(Rails.application.config.csv_parser_options)) do |chunk|
        ImportJob.perform_later(config, chunk)
      end
      flash[:notice] = "Background import job running. Check back periodically for results."
      redirect_to batches_path
    else
      flash[:error] = "There was an error processing the uploaded file."
      redirect_to import_path
    end
  end

end
