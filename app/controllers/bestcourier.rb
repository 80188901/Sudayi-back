Fancyshpv2::App.controllers :bestcourier do
    use Rack::Cors do
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end 


get :main do
  render :main,:layout=>false
end  

get :order_info do
	@order=Order.find(params[:order_id])
	@setting=Setting.last
	render :order_info,:layout=>false
end

get :table do
  @nodes=Node.all
  render :table,:layout=>false
end


get :settime do
  @setting=Setting.last
  render :settime,:layout=>false
  end


  get :setnode do
    @nodes=Node.all
    render :setnode,:layout=>false
  end


  get :setcourier do
      @account=Account.where(mobile: '15817378124').first
  @couriers=Employee.where(account_id:@account._id)
  @couriers.each do |courier|
    if courier.whenfree.to_i<Time.now.to_i
      courier.isfree=true
      courier.whenfree=''
      courier.save
    end
  end
    render :setcourier,:layout=>false
  end


  get :order do
    @account=Account.where(mobile: '15817378124').first
  @couriers=Employee.where(account_id:@account._id)
  @couriers.each do |courier|
    if courier.whenfree.to_i<Time.now.to_i
      courier.isfree=true
      courier.whenfree=''
      courier.save
    end
  end
  @node_ways=NodeWay.where(node_id:@account.node._id)
  @order=Order.new
  orders=Order.where(account_id:@account._id,iscomplete:false)
  orders.each do |order|
	time=order.created_at+order.usetime.minute
	if order.order_time
		time+=order.order_time.time_diff.minute
	end
    if time.to_i<Time.now.to_i
    order.iscomplete=true
    order.isnow=false
                order.level=0
    order.save
    neworders=order.employee.orders.where(iscomplete:false).asc(:created_at)
                          neworders.each_with_index do |neworder,index|
                            if index==0
             neworder.isnow=true
                                neworder.level=1
                         neworder.save
                            else
                                  neworder.level=neworder.level-1
                                  neworder.save
    		            end
                        end
    end
  end

  @orders=Order.where(account_id:@account._id,iscomplete:false).desc(:isnow)
    render :order,:layout=>false
  end


get :del_all_order do
  Order.all.each do |order|
    order.order_time.destroy
    order.destroy
 end
	Employee.all.each do |employee|
	employee.update_attributes(isfree:true,whenfree:'')
	end

redirect(url(:bestcourier,:order))
end



  get :add_order do

    render :add_order,:layout=>false
  end
  get :order_flow do
    @courier=Employee.find(params[:courier_id])
    @orders=@courier.orders.asc(:created_at) 
    render :order_flow,:layout=>false
  end
get :get_node do
	store=Store.find(params[:store_id])
	render :html,store.node.name
end

get :update_node_way do
    node_way=NodeWay.where(node_id:params[:node_id],tonode:params[:tonode]).first
    if params[:time]
    node_way.update_attribute(:time,params[:time].chop)
  else
    node_way.update_attribute(:fee,params[:fee].chop)
  end
    resp=node_way.node.number+','+Node.find(node_way.tonode).number
   render :html,resp.to_json
end
post :update_time ,:csrf_protection => false do
  setting=Setting.last
  if   params[:store_time]=='on'
    setting.store_time=0
  else

    setting.store_time=params[:store_time].to_i
  end
   if   params[:courier_time]=='on'
    setting.courier_time=0
     else

    setting.courier_time=params[:courier_time].to_i
  end
   if   params[:store_vali_time]=='on'
    setting.store_vali_time=0
     else

    setting.store_vali_time=params[:store_vali_time].to_i
  end
   if  params[:customer_vali_time]=='on'
    setting.customer_vali_time=0
     else

    setting.customer_vali_time=params[:customer_vali_time].to_i
  end
setting.complete_after=params[:complete_after]
setting.save
  redirect(url(:bestcourier,:settime)) 
end

  post :create_order ,:csrf_protection => false do
    @account = Account.where(_id:params[:account_id]).first
    puts @account
    @node = @account.node
    setting=Setting.last
    warehouse=Store.find(params[:store_id])
    node_good=warehouse.node
    node_customer=Node.find(params[:customer_node])
    to_good_way=NodeWay.where(node_id:@node._id,tonode:node_good._id).first
    to_customer_way=NodeWay.where(node_id:node_good._id,tonode:node_customer._id).first
    company_usetime=to_good_way.time+to_customer_way.time+setting.store_time+setting.store_vali_time+setting.courier_time+setting.customer_vali_time
      other_usetime=[]
  

     couriers=Employee.where(account_id:@account._id,isfree:false)
  

     couriers.each do |courier|
        order=courier.orders.desc(:level).first  
        node=Node.find(order.node_id)
       
        my_to_good_way=NodeWay.where(node_id:node._id,tonode:node_good._id).first
    #   if  (courier.whenfree.to_i-Time.now.to_i)/60>(setting.store_time+setting.courier_time)
    #    usetime=(courier.whenfree.to_i-Time.now.to_i)/60+my_to_good_way.time+to_customer_way.time+setting.store_vali_time
     #   other_usetime<<usetime
     # if  (courier.whenfree.to_i-Time.now.to_i)/60>setting.store_time
     #    usetime=(courier.whenfree.to_i-Time.now.to_i)/60+my_to_good_way.time+to_customer_way.time+setting.store_vali_time+setting.courier_time
   #  other_usetime=[]
     #   other_usetime<<usetime
   #   else
        usetime=(courier.whenfree.to_i-Time.now.to_i)/60+my_to_good_way.time+to_customer_way.time+setting.store_time+setting.store_vali_time+setting.courier_time+setting.customer_vali_time
        other_usetime<<usetime
  #   end
   end
  

   queding_usetime=1111111100
   index=''

     other_usetime<<company_usetime
     other_usetime.each_with_index do |a,b|
              if a<queding_usetime
                  queding_usetime=a
                  index=b
              end
     end
  puts other_usetime
  puts '||||||'
   number=(Order.count+1).to_s
	if number.length<6
		(6-number.length).times do
		number='0'+number
		end
	end

      if index=other_usetime.size-1

              @courier=Employee.where(isfree:true).first     
                if @courier
                @order=Order.new()
                @order.isnow=true
                @order.usetime=queding_usetime
                @order.account_id=@account._id
                @order.employee_id=@courier._id
                @order.node_id=node_customer._id
                @order.store_id=warehouse._id
		@order.firstnode=@account.node._id
		@order.create_order_time
                  @order.level=1
                  @order.number=number
                if @order.save!
                    @courier.isfree=false
                    @courier.whenfree=Time.now+@order.usetime.minute
                    @courier.save
                end
                
              else
           
                other_usetime.delete_at(index)
              queding_usetime=100000
                  other_usetime.each_with_index do |a,b|
              if a<queding_usetime
                  queding_usetime=a
                  index=b

              end
            end
        puts other_usetime


              @courier=couriers[index]

              @order=Order.new(usetime:queding_usetime,account_id:@account._id,employee_id:@courier._id,node_id:node_customer._id,store_id:warehouse._id)
		   @order.firstnode=@courier.orders.desc(:level).first.node._id
                    @order.number=number
                  level=@courier.orders.where(iscomplete:false).max(:level)+1
                  @order.level=level
		@order.create_order_time
              if @order.save!
                   @courier.whenfree=@order.created_at+@order.usetime.minute
 
                    @courier.save
              end
              end
      else

              @courier=couriers[index]
             
              @order=Order.new(usetime:queding_usetime,account_id:@account._id,employee_id:@courier._id,node_id:node_customer._id,store_id:warehouse._id)
		   @order.firstnode=@courier.orders.desc(:level).first.node._id
			@order.create_order_time
             level=@courier.orders.where(iscomplete:false).max(:level)+1
                  @order.level=level
                  @order.number=number
             if @order.save!
                    @courier.whenfree=@order.created_at+@order.usetime.minute
                    @courier.save
             end      
      end
  redirect(url(:bestcourier,:order)) 
  end


     get :delete_node do
    
      node = Node.where(_id: params[:node_id]).first
      if node
        node.destroy
      end
redirect(url(:bestcourier,:table))


  end
get :complete_process do
  order=Order.find(params[:order_id])
  setting=Setting.last
 case params[:process]
  when '1'
   time=Order.get_start_time(order._id)+setting.store_time.minute
   order.order_time.store_time=Time.now
   order.order_time.time_diff=(Time.now.to_i-time.to_i)/60
   order.order_time.save
   order.employee.whenfree+=((Time.now.to_i-time.to_i)/60).minute
   order.employee.save
   orders=order.employee.orders.where(:level.gt=>order.level)
   orders.each do |a|
        a.usetime+=(Time.now.to_i-time.to_i)/60
        a.save
   end
  when '2'
    node_way=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first
    time=Order.get_start_time(order._id)+setting.store_time.minute+node_way.time.minute+order.order_time.time_diff.minute
   order.order_time.first_node_way_time=Time.now
   order.order_time.time_diff+=(Time.now.to_i-time.to_i)/60
   order.order_time.save
	order.employee.whenfree+=((Time.now.to_i-time.to_i)/60).minute
        order.employee.save
          orders=order.employee.orders.where(:level.gt=>order.level)
   orders.each do |a|
        a.usetime+=(Time.now.to_i-time.to_i)/60
        a.save
   end
  when '3'
       node_way=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first
    time=Order.get_start_time(order._id)+setting.store_time.minute+node_way.time.minute+order.order_time.time_diff.minute+setting.store_vali_time.minute
   order.order_time.store_vali_time=Time.now
   order.order_time.time_diff+=(Time.now.to_i-time.to_i)/60
   order.order_time.save
	order.employee.whenfree+=((Time.now.to_i-time.to_i)/60).minute
        order.employee.save
          orders=order.employee.orders.where(:level.gt=>order.level)
   orders.each do |a|
        a.usetime+=(Time.now.to_i-time.to_i)/60
        a.save
   end
  when '4'
    node_way=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first
    node_way2=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first
    time=Order.get_start_time(order._id)+setting.store_time.minute+node_way.time.minute+order.order_time.time_diff.minute+setting.store_vali_time.minute+node_way2.time.minute
   order.order_time.end_node_way_time=Time.now
   order.order_time.time_diff+=(Time.now.to_i-time.to_i)/60
   order.order_time.save
	order.employee.whenfree+=((Time.now.to_i-time.to_i)/60).minute
        order.employee.save
          orders=order.employee.orders.where(:level.gt=>order.level)
   orders.each do |a|
        a.usetime+=(Time.now.to_i-time.to_i)/60
        a.save
   end
  when '5'
     node_way=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first
    node_way2=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first
    time=Order.get_start_time(order._id)+setting.store_time.minute+node_way.time.minute+order.order_time.time_diff.minute+setting.store_vali_time.minute+node_way2.time.minute+setting.customer_vali_time.minute
   order.order_time.customer_time=Time.now
   order.order_time.time_diff+=(Time.now.to_i-time.to_i)/60
   order.order_time.save
	order.employee.whenfree+=((Time.now.to_i-time.to_i)/60).minute
        order.employee.save
          orders=order.employee.orders.where(:level.gt=>order.level)
   orders.each do |a|
        a.usetime+=(Time.now.to_i-time.to_i)/60
        a.save
   end
    when '6'
	 time=Order.get_start_time(order._id)
   order.order_time.courier_time=Time.now
   order.order_time.time_diff=(Time.now.to_i-time.to_i)/60
   order.order_time.save
        order.employee.whenfree+=((Time.now.to_i-time.to_i)/60).minute
        order.employee.save
          orders=order.employee.orders.where(:level.gt=>order.level)
   orders.each do |a|
        a.usetime+=(Time.now.to_i-time.to_i)/60
        a.save
   end

  end
 render :html,'true'
end

  post :delete_order do
     order=Order.find(params[:order_id])
     if order
      employee=order.employee
	if employee.orders.where(iscomplete:false).count==1
   		employee.isfree=true
     	        employee.whenfree=''
     	        employee.save
       	        order.destroy
	else
		if order.isnow==true
			orders=order.employee.orders.where(iscomplete:false)
                          orders.each_with_index do |a,index|
                                if  index==0
                                   a.destroy
                                elsif index==1
                                    a.isnow=true
                                    a.level=1
                                    a.save
                                 else
                                  a.level=a.level-1
                                  a.save
                                end
                          end
		else
		     #这个快递员有大于一张订单还没完成 且删除的订单不是正在派送的
		end	
	end
     end

redirect(url(:bestcourier,:index))

  end
end
