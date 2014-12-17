Fancyshpv2::MobileAdmin.controllers :store_manager do
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
    @store = Store.new
    @store.credit_url = params[:url]
    @store.name = params[:warehouse_name]
    @store.open_time_begin_day = params[:first_time]
    @store.open_time_end_day = params[:last_time]
    @store.open_time_in_one_week = params[:day]
    @store.account_id = params[:uid]
    @store.save
    @store_address = StoreAddress.new
    @store_address.store_id = @store._id
    @store_address.area_id = params[:area_id]
    @store_address.details = params[:warehouse_address]
    @store_address.save
    @store._id.to_json
  end

  get :get_store_id do
    @store=Store.where(:name => params[:warehouse_name]).first
    @store._id.to_json
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

 post :add_product_to_store, :csrf_protection => false do
    @store_images = StoreImageItem.where(:store_id => params[:store_id])
    if @store_images
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
       if @store_image.save
           1.to_json
       else
          0.to_json
       end
    end
 end
end
