Fancyshpv2::Admin.controllers :add_product do
  
  get :index do
    render 'add_product/index'
  end

  post :set_level do
   
    @image_item = ImageItem.new
    render 'add_product/set_level'
  end

  post :create_cover do
    @image_item = ImageItem.new(params[:image_item])
    @product = Product.new
    @host = request.host
    @website = Website.where(:domain => @host ).first
   @level = params[:level]
    if @image_item.save
      @title = pat(:create_title, :model => "image_item #{@image_item.id}")
       render 'add_product/create_cover'
    else
      @title = pat(:create_title, :model => 'image_item')
     render 'add_product/set_level'
    end
  end

  get :product_create do
  end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  

end
