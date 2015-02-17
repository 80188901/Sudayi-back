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
   @products = Product.all.order_by(:created_at.desc)
    @products.to_json(:include=>:image_items)

  end

  get :get_product_by_id do
    @product = Product.find(params[:pid]) 
    @product.to_json
  end

  get :get_images_by_pid do
    @images = ImageItem.where(:product_id => params[:pid])
    puts @images.to_json
    @images.to_json

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

  get :get_products_by_cate_id do
    #广度优先算法
    arr = []
    products = {}
    outputs = Category.findLeaves(params[:cate_id],arr,true)
    arr.each_with_index do |i,j|
      products[j] = Product.where(:category_id => i)
    end
    products.to_json

  end

get :distance do
    product=Product.find(params[:product_id])
    
end

end
