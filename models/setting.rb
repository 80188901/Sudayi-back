class Setting
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :account
  # field <name>, :type => <type>, :default => <value>
  field :store_time,:type=>Integer,:default=>5
  field :courier_time,:type=>Integer,:default=>5
  field :store_vali_time,:type=>Integer,:default=>5
  field :customer_vali_time,:type=>Integer,:default=>10
  field :complete_after,:type=>String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>
 def  self.alltime
    setting=Setting.last
    time=setting.store_time+setting.courier_time+setting.store_vali_time+setting.customer_vali_time
    return time
 end
  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
