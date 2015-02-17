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
    @product.description=params[:ck_des]
    @product.price=params[:ck_price].to_f
    @product.specification=params[:ck_spec]
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

  

end
