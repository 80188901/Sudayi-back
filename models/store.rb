class Store
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :website
  belongs_to :account
  belongs_to :state
 # belongs_to :address
  has_many :orders
 belongs_to :node
  belongs_to :store_address,:dependent=>:delete
  has_many :product_store,:dependent=>:delete
  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :in_charge, :type => String
  field :open_time_begin_day, :type => String
  field :open_time_end_day, :type => String
  field :open_time_in_one_week, :type=> String
  mount_uploader :credit_url, StoreUploader
  field :credit_url, :type => String
  field :end_date,:type=>Date

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
