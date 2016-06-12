class CollectionSpaceObject
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object, counter_cache: true

  field :category,    type: String # Authority, Procedure
  field :type,        type: String
  field :identifier,  type: String
  field :title,       type: String
  field :content,     type: String
  field :transferred, type: Boolean, default: false
  # fields from remote collectionspace
  field :csid,        type: String
  field :uri,         type: String

  attr_readonly :type

  scope :transferred, ->{ where(transferred: true) }
end