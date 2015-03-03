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
 def self.get_actual_time(order_id,process)
  order=Order.find(order_id)
    order_time=order.order_time
    setting=Setting.last
    time=Order.get_start_time(order._id)
    actual_time=[]
    result=0
    first_node_way=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first.time
    end_node_way=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first.time
    if order_time.courier_time
    actual_time<<(order_time.courier_time.to_i-time.to_i)/60
  else
    actual_time<<0
   end

   if order_time.store_time
    actual_time<<(order_time.store_time.to_i-(time+setting.store_time.minute).to_i)/60
      else
    actual_time<<0
  end

    if order_time.first_node_way_time
      actual_time<<(order_time.first_node_way_time.to_i-(time+setting.store_time.minute+first_node_way.minute).to_i)/60
        else
    actual_time<<0
    end

    if order_time.store_vali_time
      actual_time<<(order_time.store_vali_time.to_i-(time+setting.store_time.minute+first_node_way.minute+setting.store_vali_time.minute).to_i)/60
        else
    actual_time<<0
    end

    if order_time.end_node_way_time
       actual_time<<(order_time.store_vali_time.to_i-(time+setting.store_time.minute+first_node_way.minute+setting.store_vali_time.minute+end_node_way.minute).to_i)/60
  else
    actual_time<<0
    end

    if order_time.customer_time
            actual_time<<(order_time.store_vali_time.to_i-(time+setting.store_time.minute+first_node_way.minute+setting.store_vali_time.minute+end_node_way.minute+setting.customer_vali_time.minute).to_i)/60
         else
    actual_time<<0
    end
    case process
    when '1'
      result=actual_time[0]
    when '2'
	if actual_time[1]==0
	result=0
	else
      result=actual_time[1]-actual_time[0]
	end
    when '3'
	 if actual_time[2]==0
        result=0
        else
       result=actual_time[2]-actual_time[1]
	end
    when '4'
	 if actual_time[3]==0
        result=0
        else
      result=actual_time[3]-actual_time[2]
	end
    when '5'
	 if actual_time[4]==0
        result=0
        else
         result=actual_time[4]-actual_time[3]
	end
    when '6'
	 if actual_time[5]==0
        result=0
        else
       result=actual_time[5]-actual_time[4]
	end
    when '7'
	 if actual_time[2]==0
        first_time=0
        else
	first_time=actual_time[2]-actual_time[1]
	end
	 if actual_time[4]==0
        end_time=0
        else
	end_time=actual_time[4]-actual_time[3]
	end
        result=order_time.time_diff-first_time-end_time
    end

    return result
 end
  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
