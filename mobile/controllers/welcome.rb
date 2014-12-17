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
    @image_items = {}
    @products .each_with_index do |product, index|
       @image_item = ImageItem.where(:product_id => product._id).first
       @image_items[index] = @image_item
    end
    @image_items.to_json
  end

  get :get_product_by_id do
    @product = Product.find(params[:pid]) 
    @product.to_json
  end

  get :get_images_by_pid do
    @images = ImageItem.where(:product_id => params[:pid])
    @images.to_json
  end

  get :get_products_by_cate_id do
    @products = Product.where(params[:cate_id])
    @products.to_json
  end

  get :get_cates do
    @fcate = Category.where(:name => '根').first
    @cates = Category.where(:category_id => @fcate._id)
    @cates.to_json
  end

  get :get_sub_cates do
    @cates = Category.where(:category_id =>params[:fid])
    @cates.to_json
  end

  get :get_product_by_cate_id do
    @products = Product.where(:category_id =>params[:cate_id])
    @products.to_json
  end

end
