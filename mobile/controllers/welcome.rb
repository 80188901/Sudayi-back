Fancyshpv2::Mobile.controllers :welcome do
  
  use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
 end 
  
  get :all_pics do
    @image_items = ImageItem.all.order_by(:created_at.desc)
    @image_items.to_json
  end

end
