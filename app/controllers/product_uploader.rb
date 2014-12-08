Fancyshpv2::App.controllers :product_uploader do
    use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end 
  
  get :index do
    @product = Product.new
    @product.save
    @product.to_json
  end

end
