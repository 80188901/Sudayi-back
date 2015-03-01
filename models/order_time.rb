class OrderTime
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :order
  # field <name>, :type => <type>, :default => <value>
    field :store_time,:type=>DateTime
    field :courier_time,:type=>DateTime
    field :store_vali_time,:type=>DateTime
    field :customer_time,:type=>DateTime
    field :first_node_way_time,:type=>DateTime
    field :end_node_way_time,:type=>DateTime
    field :real_complete_time,:type=>DateTime
    field :time_diff,:type=>Integer,:default=>0

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
