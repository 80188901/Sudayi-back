Fancyshpv2::App.controllers :product_uploader do
    use Rack::Cors do
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end 
  


  post :create_adv,  :csrf_protection => false  do
   @image_item = ImageItem.new
   @image_item.product_id = params[:product_id]
   @image_item.url = params[:adv_url]
   @image_item.account_id = params[:uid]
   @product.storage = 0
   @image_item.name = '广告'
   @image_item.iscover = 0
   @image_item.save
   @image_item.to_json
  end
  
  post :create_cover,  :csrf_protection => false  do
   @image_item = ImageItem.new
   @image_item.product_id = params[:product_id]
   @product = Product.find(params[:product_id])
   @product.level = params[:level]
   @product.save
   @image_item.url = params[:cover_url]
    @image_item.account_id = params[:uid]
   @image_item.name = '封面'
   @image_item.iscover = 1
   @image_item.save
   @image_item.to_json
  end

  get :get_stores_by_account do 
    @stores = Store.where(:account_id=>params[:uid])
    if @stores
    @stores.to_json
    else
    0.to_json
    end
  end

  post :create_details,  :csrf_protection => false  do
   @image_item = ImageItem.new
   @image_item.product_id = params[:product_id]
   @image_item.url = params[:file]
    @image_item.account_id = params[:uid]
   @image_item.name = '细节'
   @image_item.iscover = 0
   @image_item.save
   @image_item.to_json
  end

   post :create_other_details,  :csrf_protection => false  do
   @image_item = ImageItem.new
   @image_item.product_id = params[:product_id]
   @image_item.url = params[:file]
    @image_item.account_id = params[:uid]
   @image_item.name = params[:name]
   @image_item.price = params[:price]
   @image_item.iscover = 0
   @image_item.save
   @image_item.to_json
  end



    get :index do
    @product = Product.new
    @product.save
    @product.to_json
  end

  get :get_root do
    @category = Category.where(:name => '根' ).first
    @categories=Category.where(:category_id => @category._id)
    @categories .to_json
  end

  get :get_nodes do
    @category = Category.find(params[:cate_id])
    @categories=Category.where(:category_id => @category._id)
    if @categories
      @categories.to_json
    else
      0.to_json
    end
  end

  post :create_other_product_details,  :csrf_protection => false do
    @product = Product.find(params[:product_id])
    @product.name = params[:good_name]
    @product.description = params[:description]
    @product.category_id = params[:cate_id]
    @product.account_id = params[:uid]
    @product.storage  = 1
    @state=State.all.first
    @product.state_id = @state._id
    @product.save
    @product.to_json
  end
 
end
