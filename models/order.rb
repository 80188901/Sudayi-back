class Order
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :cart
  belongs_to :account
  belongs_to :address
   belongs_to :node
   belongs_to :store
   belongs_to :employee
   field :number,:type=>String
  field :firstnode,:type=>String
  field :price, :type => Float
  field :iscomplete,:type=>Boolean,:default=>false
  field :isnow,:type=>Boolean,:default=>false
  field :usetime,:type=>Integer,:default=>''
  field :level,:type=>Integer
  # field <name>, :type => <type>, :default => <value>
  
def  self.get_now_node (order_id)
  order=Order.find(order_id)
  time=order.created_at+order.usetime.minute
    surplus=(time.to_i-Time.now.to_i)/60
    setting=Setting.last
   node_way=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first.time
 node=[]
  if surplus<(node_way+setting.customer_vali_time)
    
    node<<order.store.node.name
    node<<order.node.name
  else
   
     node<< Node.find(order.firstnode).name
     node<<order.store.node.name
  end

  return node
end
def self.get_start_time(order_id)
 setting=Setting.last
 order=Order.find(order_id)
 node_way1=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first
 node_way2=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first
time=(order.created_at+order.usetime.minute)-(node_way1.time+node_way2.time+setting.store_time+setting.store_vali_time+setting.customer_vali_time).minute

return time
  end

  def self.get_now_process(number,order_id)
      order=Order.find(order_id)
  time=order.created_at+order.usetime.minute
    surplus=(time.to_i-Time.now.to_i)/60
    setting=Setting.last
   node_way2=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first.time
   node_way1=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first.time
   compare=0
   if surplus<0
    compare=5
     elsif surplus<=setting.customer_vali_time
     compare=4
     elsif surplus<=node_way2+setting.customer_vali_time
      compare=3
    elsif  surplus<=node_way2+setting.customer_vali_time+setting.store_vali_time
      compare=2
    elsif surplus<=node_way2+setting.customer_vali_time+setting.store_vali_time+node_way1
      compare=1
    end
    if number<=compare
      return true
    else
      return false
    end

  end
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>
 
  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
