class Address
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
   belongs_to :planet
   belongs_to :country
   belongs_to :province
   belongs_to :city
   belongs_to :area
   belongs_to :street
   belongs_to :detail
   belongs_to :account
  # field <name>, :type => <type>, :default => <value>
  

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
