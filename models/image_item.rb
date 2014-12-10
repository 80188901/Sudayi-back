class ImageItem
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

   belongs_to :product
   belongs_to :account
   belongs_to :website
   mount_uploader :url, AvatarUploader
  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :url, :type => String
  field :iscover, :type => Integer
  field :price, :type => Float
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
