Fancyshpv2::MobileAdmin.controllers :store_manager do
 require 'date'
 require 'json'
  use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
 end 
  
  get '/' do
    'hello'
  end

  post :new_store,:csrf_protection => false do
	logger.info params
   if params[:url] and params[:warehouse_name] and params[:end_date] and params[:user_id] and params[:node_id] and params[:warehouse_address]
    if !Store.where(name:params[:warehouse_name]).first	
     @store = Store.new
     @store.credit_url = params[:url]
     @store.name = params[:warehouse_name]
   # @store.open_time_begin_day = params[:first_time]
   # @store.open_time_end_day = params[:last_time]
   # @store.open_time_in_one_week = params[:day]
     @store.end_date=Date.parse(params[:end_date])
     @store.account_id = params[:user_id]
     @store.node_id=params[:node_id] 
     state=State.where(code:0).first
     @store.state=state
     @store_address = StoreAddress.new
     @store_address.details = params[:warehouse_address]
     @store_address.save
     @store.store_address=@store_address
     @store.save
     @store._id.to_json
    else
	'仓库已存在'.to_json
    end
   else
    '请将信息填写完整'.to_json
   end
  end

  get :get_store_id do
    @store=Store.where(:name => params[:warehouse_name]).first
    @store._id.to_json
  end
  get :get_all_store do
 	stores=Store.where(account_id:params[:user_id])
	if !stores.empty?
	stores.to_json(:include=>{:store_address=>{:only=>:details},:node=>{:include=>{:city=>{:only=>:name},:area=>{:only=>:name}},:only=>[:city]}},:only=>[:_id,:name])
	else
	"此账号不存在仓库".to_json
	end
  end

  get :judge_store_name do
    @store=Store.where(:name => params[:warehouse_name])
    if @store
      0.to_json
    else
      1.to_json
    end
  end

  post :new_account_in_charge,:csrf_protection => false do
     @account = Account.new(:password_confirmation => params[:apwd], :role=>'admin', :name => params[:user], :mobile => params[:tel], :password => params[:pwd], :admin_type => params[:way], :email => params[:email])
    if @account.save
       @employee = Employee.new(:emp => @account._id,:account_id => params[:uid])
      if @employee.save
        @employee.to_json
      else
        '保存不成功'.to_json
      end
    else
      '保存未成功'.to_json
    end
  end


  get :get_employees_by_account do
    @employees = Employee.where(:account_id => params[:uid])
    @employees.to_json
  end

  get :get_account_by_id do
    @account = Account.find(params[:employee_id])
    @account.to_json
  end

  post :insert_product_to_store,:csrf_protection => false do
	store=Store.find(params[:store_id])
	if store
	  ((params.size-1)/2).times do |index|
	    if params['amount'+index.to_s]!=""
	      product_collection=ProductCollection.find(params['c_id'+index.to_s])
	      amount=params['amount'+index.to_s].to_i
		if product_collection.no_store>=amount
	logger.info "d"
	           product_store= ProductStore.where(product_collection_id:params['c_id'+index.to_s],store_id:params[:store_id]).first
	           if !product_store
	logger.info "f"
	             product_store=ProductStore.new
	             product_store.store=store
	             product_store.product_collection=product_collection
	             product_store.amount=amount
	           else
	             product_store.amount+=amount
	           end
	           product_store.save
 	           product_collection.no_store-=amount
	           product_collection.save
                 else
			render :html,"请填写真确的数量"
		 end
	    end
	  end
	  render :html,"true"
	else
	  "仓库不存在".to_json
	end
  end


  post :assign_employee_job, :csrf_protection => false do
    @store_employee = StoreEmployee.new(:store_id => params[:store_id], :employee_id => params[:employee_id], :info_access => params[:ware_notice],:is_charge =>params[:ware_link])
    if @store_employee.save
      1.to_json
    else
      0.to_json
    end
  end

 get :get_stores_by_uid do
     @stores= Store.where(:account_id => params[:uid])
     @stores.to_json
 end
 
 get :get_details_by_product_id do
  @image_items = ImageItem.where(:isdetail => 1, :product_id => params[:pid])
  @image_items.to_json
 end

 get :add_product_to_store, :csrf_protection => false do
    @store_images = StoreImageItem.where(:store_id => params[:store_id])
    if @store_images.nil?
      @store_images.each do |store_image|
        if store_image.price != params[:price].to_f
            store_image.price = params[:price].to_f
        end
         if store_image.storage != params[:number].to_i
            store_image.storage = params[:number].to_i
        end
        if store_image.image_item_id != params[:gid]
           store_image.image_item_id = params[:gid]
        end
        if store_image.save
          1.to_json
        else
          0.to_json
        end
      end
    else
       @store_image = StoreImageItem.new(:store => params[:store_id], :image_item_id => params[:gid], :price =>params[:price], :storage => params[:number])
       @store_image.save!
      
    end
   @store_images.to_json
 end
end
