Fancyshpv2::App.controllers :bestcourier do
    use Rack::Cors do
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end 
  
get :index do
   @account=Account.where(mobile: '15817378124').first
   puts @account.node.name
  @couriers=Employee.where(account_id:@account._id)
  @node_ways=NodeWay.where(node_id:@account.node._id)
  @order=Order.new
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
  

   queding_usetime=500
   index=''

     other_usetime<<company_usetime
     other_usetime.each_with_index do |a,b|
              if a<queding_usetime
                  queding_usetime=a
                  index=b
              end
     end
  puts other_usetime

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
                if @order.save!
                    @courier.isfree=false
                    @courier.whenfree=(Time.now+@order.usetime.minute)+10.minute
                    @courier.save
                end
                
              else
           
                other_usetime.delete_at(index)
              queding_usetime=500
                  other_usetime.each_with_index do |a,b|
              if a<queding_usetime
                  queding_usetime=a
                  index=b

              end
            end
        puts other_usetime

              @courier=couriers[index]
              
              @order=Order.new(usetime:(@courier.whenfree.to_i-Time.now.to_i)/60+queding_usetime,account_id:@account._id,employee_id:@courier._id,node_id:node_customer._id,store_id:warehouse._id)
              if @order.save!

                   @courier.whenfree=(@courier.whenfree+@order.usetime.minute)+10.minute
                    @courier.save
              end
              end
      else

              @courier=couriers[index]
             
              @order=Order.new(usetime:(@courier.whenfree-Time.now)/60+queding_usetime,account_id:@account._id,employee_id:@courier._id,node_id:node_customer._id,store_id:warehouse._id)
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

      @account=Account.where(mobile: '15817378124').first
  @couriers=Employee.where(account_id:@account._id)
  @node_ways=NodeWay.where(node_id:@account.node._id)
    @orders=Order.where(account_id:@account._id,iscomplete:false)
  @order=Order.new
    #=============================

      render 'bestcourier/index'

  end

  post :delete_order do
     order=Order.find(params[:order_id])
     if order
      employee=order.employee
      employee.isfree=true
      employee.whenfree=''
      employee.save
        order.destroy
     end
      @account=Account.where(mobile: '15817378124').first
  @couriers=Employee.where(account_id:@account._id)
  @node_ways=NodeWay.where(node_id:@account.node._id)
    @orders=Order.where(account_id:@account._id,iscomplete:false)
  @order=Order.new
   render 'bestcourier/index'
  end
end
