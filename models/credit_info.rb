class CreditInfo
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  belongs_to :province
  belongs_to :city
  belongs_to :area
  belongs_to :state
  belongs_to :firm_type
  field :name, :type => String
  field :email, :type => String
  field :card_id, :type => String
  mount_uploader :url, CreditUploader
  mount_uploader :url2, CreditAgainUploader
  field :url, :type => String
  field :url2, :type =>String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
