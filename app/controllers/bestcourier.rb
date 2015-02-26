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
get :table do
  @nodes=Node.all
  render :table,:layout=>false
end
get :settime do
  render :settime,:layout=>false
  end
  get :setnode do
    render :setnode,:layout=>false
  end
  get :setcourier do
    render :setcourier,:layout=>false
  end
  get :order do
    render :order,:layout=>false
  end
  get :add_order do
    render :add_order,:layout=>false
  end
  get :order_flow do
    render :order_flow,:layout=>false
  end
get :get_node do
	store=Store.find(params[:store_id])
	render :html,store.node.name
end
get :index do
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
		if (order.created_at+order.usetime.minute).to_i<Time.now.to_i
		order.iscomplete=true
		order.isnow=false
                order.level=0
		order.save
		neworders=order.employee.orders.where(iscomplete:false)
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
	@orders=Order.where(account_id:@account._id,iscomplete:false)

   render 'bestcourier/index'
end

  post :create_order ,:csrf_protection => false do
    @account = Account.where(_id:params[:account_id]).first
    @node = @account.node
    warehouse=Store.find(params[:store_id])
    node_good=warehouse.node
    node_customer=Node.find(params[:customer_node])
    to_good_way=NodeWay.where(node_id:@node._id,tonode:node_good._id).first
    to_customer_way=NodeWay.where(node_id:node_good._id,tonode:node_customer._id).first
    company_usetime=to_good_way.time+to_customer_way.time+5+5
      other_usetime=[]
  

     couriers=Employee.where(account_id:@account._id,isfree:false)
  

     couriers.each do |courier|
        order=courier.orders.where(isnow:true).first  
        node=Node.find(order.node_id)
       
        my_to_good_way=NodeWay.where(node_id:node._id,tonode:node_good._id).first
        if  (courier.whenfree.to_i-Time.now.to_i)/60>5
        usetime=(courier.whenfree.to_i-Time.now.to_i)/60+my_to_good_way.time+to_customer_way.time+5
        other_usetime<<usetime
      else
        usetime=(courier.whenfree.to_i-Time.now.to_i)/60+my_to_good_way.time+to_customer_way.time+5+5
        other_usetime<<usetime
     end
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
                  @order.level=1
                if @order.save!
                    @courier.isfree=false
                    @courier.whenfree=(Time.now+@order.usetime.minute)+10.minute
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
              @order=Order.new(usetime:(@courier.whenfree.to_i-Time.now.to_i)/60+queding_usetime,account_id:@account._id,employee_id:@courier._id,node_id:node_customer._id,store_id:warehouse._id)
		   @order.firstnode=@courier.orders.where(isnow:true).first.node._id

                  level=@courier.orders.where(iscomplete:false).max(:level)+1
                  @order.level=level
              if @order.save!

                   @courier.whenfree=(@courier.whenfree+@order.usetime.minute)+10.minute
                    @courier.save
              end
              end
      else

              @courier=couriers[index]
             
              @order=Order.new(usetime:(@courier.whenfree-Time.now)/60+queding_usetime,account_id:@account._id,employee_id:@courier._id,node_id:node_customer._id,store_id:warehouse._id)
		   @order.firstnode=@courier.orders.where(isnow:true).first.node._id
     
             level=@courier.orders.where(iscomplete:false).max(:level)+1
                  @order.level=level
             if @order.save!
                    @courier.whenfree=(@courier.whenfree+@order.usetime.minute)+10.minute
                    @courier.save
             end      
      end
  redirect(url(:bestcourier,:index)) 
  end
     post :delete_node_way do
      logger.info params[:node_way_id]
      node_way = NodeWay.where(_id: params[:node_way_id]).first
      if node_way
        logger.info node_way.to_json
        @new_settle = '［'+Node.find(node_way.node_id).name+'
      ］到［'+Node.find(node_way.tonode).name+'］的距离删除成功!'
        node_way.destroy
      end
      logger.info node_way.to_json
      #============================
    #页面数据维持


    #=============================

redirect(url(:bestcourier,:index))


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
