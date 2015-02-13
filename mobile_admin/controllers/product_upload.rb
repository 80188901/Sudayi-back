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
    @product=Product.new()
    @product.name=params[:name]
    @product.description=params[:description]
    @product.price=params[:price]
    @product.storage=params[:storage]
    
end
  

end
