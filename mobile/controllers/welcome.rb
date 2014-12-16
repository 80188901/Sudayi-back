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

  get :get_pics_a do
    @products = Product.where(:level => 1).order_by(:created_at.desc)
    @products .each_with_index do |product, index|
       @image_item = ImageItem.where(:product_id => product._id).first
       @image_items[index] = @image_item
    end
    @image_items.to_json
  end

end
