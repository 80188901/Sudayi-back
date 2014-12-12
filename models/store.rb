class Store
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :website
  belongs_to :account
  belongs_to :address
  

  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :in_charge, :type => String
  field :open_time, :type => String
  field :open_time_in_one_week, :type=> String
  mount_uploader :credit_url, StoreUploader
  field :credit_url, :type => String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
