Fancyshpv2::MobileAdmin.controllers :product_upload do
      use Rack::Cors do
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end 

post :create_product, :csrf_protection=>false do
   if params[:ck_name]
    @product=Product.new()
    @product.name=params[:ck_name]
    @product.account_id=params[:user_id]
    @product.description=params[:ck_des]
	product_collection=ProductCollection.new
    product_collection.price=params[:ck_price].to_f
    product_collection.product=@product
    product_collection.specification=params[:ck_spec]
    product_collection.storage=params[:ck_storage].to_i
    product_collection.no_store=params[:ck_storage].to_i
    product_collection.save
  #  @product.store=Store.create()
         if params[:uploadkey1]
         image_item = ImageItem.new
       image_item.url = params[:uploadkey1]
        @product.image_items<<image_item
       image_item.save!
   end
     if params[:uploadkey2]
         image_item = ImageItem.new
       image_item.url = params[:uploadkey2]
        @product.image_items<<image_item
    image_item.save!
   end
        if params[:uploadkey3]
         image_item = ImageItem.new
        image_item = ImageItem.new
       image_item.url = params[:uploadkey3]
     @product.image_items<<image_item
    image_item.save!
   end
     if params[:uploadkey4]
         image_item = ImageItem.new
       image_item.url = params[:uploadkey4]
    @product.image_items<<image_item
     image_item.save!
    end
     if params[:uploadkey5]
         image_item = ImageItem.new
       image_item.url = params[:uploadkey5]
    @product.image_items<<image_item
     image_item.save!
    end
    @product.save!
end
  end

get :warehouse_all_product do
        if params[:user_id]
	product_collections=ProductCollection.where(:no_store.gt=>0)
	products=[]
	product_collections.each do |product_collection|
	 if Product.where(account_id:params[:user_id],:_id=>product_collection.product._id).first
	products<<product_collection.product
	 end
	end
	products.to_json(:include=>:product_collections)
 	else
	'1'.to_json
	end
end
  

end
