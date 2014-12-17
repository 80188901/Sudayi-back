class StoreImageItem
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :image_item
  belongs_to :store
  # field <name>, :type => <type>, :default => <value>
  field :price, :type => Float
  field :storage, :type => Integer

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
