class Node
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :city
  belongs_to :area
  has_many :node_ways
  has_many :orders

 field :name,:type=>String
 field :number,:type=>String
 field :streets,:type=>Array
  

  # field <name>, :type => <type>, :default => <value>
  

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
