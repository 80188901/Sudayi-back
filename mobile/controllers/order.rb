Fancyshpv2::Mobile.controllers :order do
  use Rack::Cors do 
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end 
post :create_order, :csrf_protection=>false do
	@account = Account.find('54d4819fcc3007823d000001')
    @node = @account.node
    setting=Setting.last
    product=Product.find(params[:product_id])
	if product.product_collections.first.product_stores.first.amount>0
   warehouse=product.product_collections.first.product_stores.first.store
    node_good=warehouse.node
    node_customer=Node.find(params[:user_node])
    to_good_way=NodeWay.where(node_id:@node._id,tonode:node_good._id).first
    to_customer_way=NodeWay.where(node_id:node_good._id,tonode:node_customer._id).first
    company_usetime=to_good_way.time+to_customer_way.time+setting.store_time+setting.store_vali_time+setting.courier_time+setting.customer_vali_time
      other_usetime=[]

     couriers=Employee.where(account_id:@account._id,isfree:false)
  

     couriers.each do |courier|
        order=courier.orders.desc(:level).first  
        node=Node.find(order.node_id)
       
        my_to_good_way=NodeWay.where(node_id:node._id,tonode:node_good._id).first

        usetime=(courier.whenfree.to_i-Time.now.to_i)/60+my_to_good_way.time+to_customer_way.time+setting.store_time+setting.store_vali_time+setting.courier_time+setting.customer_vali_time
        other_usetime<<usetime

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
		product_collection=product.product_collections.first
		product_collection.storage-=1
		product_store=product_collection.product_stores.first
		product_store.amount-=1
		product_store.save
		product_collection.save
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
		 product_collection=product.product_collections.first
                product_collection.storage-=1
		product_store=product_collection.product_stores.first
                product_store.amount-=1
                product_store.save
                product_collection.save
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
			 product_collection=product.product_collections.first
                product_collection.storage-=1
		product_store=product_collection.product_stores.first
                product_store.amount-=1
                product_store.save
                product_collection.save
                    @courier.save
             end      
      end
	render :html,(queding_usetime-setting.customer_vali_time).to_s+"分钟"
	else
	render :html,'商品已经没货了'
	end
end

  

end
