Fancyshpv2::App.controllers :courier do
 use Rack::Cors do 
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end

post :login, :csrf_protection=>false do
	account=Account.authenticate_mobile(params[:mobile],params[:password])
	if account&&account.role=="kuaidiyuan"
	   account._id.to_s
	else
	   "手机或密码错误"
	end
end 

get :info do
	employee=Employee.where(emp:params[:user_id]).first
	account=Account.find(params[:user_id])
	if employee
		("["+employee.to_json(:only=>[:_id,:name,:isfree])+","+account.to_json(:include=>{:node=>{:include=>{:city=>{:only=>[:name]}},:only=>[:city]}},:only=>[:mobile])+"]")
	else
		"快递员id错误"	
	end
end

get :new_order do
	employee=Employee.find(params[:em_id])
	order=employee.orders.first
	if order
		render :html,"true"
	else
		render :html,"false"
	end
end
  
get :get_new_order do
	if params[:em_id]
	employee=Employee.find(params[:em_id])
	orders=employee.orders
	orders.to_json
	end	
end

get :get_node do
	node=Node.find(params[:node_id])
	if node
		node.name.to_json
	else
		"区id错误"
	end
end

get :get_store_info do
	store=Store.find(params[:store_id])
	if store
	    store.to_json(:include=>{:store_address=>{:only=>[:details]},:node=>{:only=>[:name]}},:only=>[:name])
	else
	    "仓库不存在"
	end
end

get :vali_time do
	order=Order.find(params[:order_id])
	order.order_time.store_time=Time.now
	order.order_time.time_diff=(order.created_at+5.minute-Time.now)/60
	order.order_time.save
end

get :order do
	if params[:order_id]
	order=Order.find(params[:order_id])
	setting=Setting.last
	order.to_json
	end
end

get :order_error do
	order=Order.find(params[:order_id])
 	error=Error.new
	order.iscomplete=true
	order.isnow=false
	order.level=0
	order.save
	if order.employee.orders.where(iscomplete:false).size>=1
	  time=order.usetime-(Time.now-Order.get_start_time(order._id))/60-order.order_time.time_diff	
	  order.employee.whenfree-=time.minute
	else
	 order.employee.isfree=true
	 order.employee.whenfree="" 
	end
	 order.employee.save
	error.name=params[:error]
	error.order=order
	error.save
end

get :store_vali do
	order=Order.find(params[:order_id])
  setting=Setting.last
	 node_way=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first
    time=Order.get_start_time(order._id)+setting.store_time.minute+node_way.time.minute+order.order_time.time_diff.minute+setting.store_vali_time.minute
   order.order_time.store_vali_time=Time.now
   order.order_time.time_diff+=(Time.now-time)/60
   order.order_time.save
	order.employee.whenfree+=((Time.now.to_i-time.to_i)/60).minute
        order.employee.save
          orders=order.employee.orders.where(:level.gt=>order.level)
   orders.each do |a|
        a.usetime+=(Time.now.to_i-time.to_i)/60
        a.save
	"#{(order.usetime-order.order_time.time_diff-(Time.now-(Order.get_start_time(order._id)-setting.courier_time.minute))/60).to_i}:00"
end
end

get :get_time do
	order=Order.find(params[:order_id])
	setting=Setting.last
	"#{(order.usetime-order.order_time.time_diff-(Time.now-(Order.get_start_time(order._id)-setting.courier_time.minute))/60).to_i}:00"
end

get :complete_order do
	order=Order.find(params[:order_id])
   setting=Setting.last
	node_way=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first
    node_way2=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first
    time=Order.get_start_time(order._id)+setting.store_time.minute+node_way.time.minute+order.order_time.time_diff.minute+setting.store_vali_time.minute+node_way2.time.minute+setting.customer_vali_time.minute
   order.order_time.customer_time=Time.now
   order.order_time.time_diff+=(Time.now.to_i-time.to_i)/60
   order.order_time.save
	order.iscomplete=true
	order.isnow=false
	order.level=0
	order.save
	if order.employee.orders.where(iscomplete:false).size>=1
		order.employee.whenfree+=((Time.now.to_i-time.to_i)/60).minute
	else
		order.employee.whenfree=""
		order.employee.isfree=true
	end
        order.employee.save
          orders=order.employee.orders.where(:level.gt=>order.level)
   orders.each do |a|
        a.usetime+=(Time.now.to_i-time.to_i)/60
	a.level-=1
	if a.level==1
		a.isnow=true
	end
        a.save
end
end
end
