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
   @image_item.name = '广告'
   @image_item.iscover = 0
   @image_item.save
   @image_item.to_json
  end
  
    post :create_cover,  :csrf_protection => false  do
   @image_item = ImageItem.new
   @image_item.product_id = params[:product_id]
   @image_item.url = params[:cover_url]
   @image_item.name = '封面'
   @image_item.iscover = 1
   @image_item.save
   @image_item.to_json
  end

  post :create_details,  :csrf_protection => false  do
   @image_item = ImageItem.new
   @image_item.product_id = params[:product_id]
   @image_item.url = params[:file]
   @image_item.name = '细节'
   @image_item.iscover = 0
   @image_item.save
   @image_item.to_json
  end



    get :index do
    @product = Product.new
    @product.save
    @product.to_json
  end

end
