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
  end
  
end
