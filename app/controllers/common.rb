Fancyshpv2::App.controllers :common do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

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
get :get_node do
	nodes=Node.where(area_id:params[:area_id])
	nodes.to_json
end
get :country do
	Country.all.to_json
end  
get :province do
	if !params[:country_id]
	country=Country.where(name:'中国').first
        Province.where(country_id:country._id).to_json
	else
	Province.where(country_id:params[:country_id]).to_json
	end
end
get :city do
	City.where(province_id:params[:province_id]).to_json
end 
get :area do
	Area.where(city_id:params[:city_id]).to_json
end
get :set_customer_node do
	session[:user_node]=params[:user_node]
	logger.info session[:user_node] 
	session[:abc]=params[:user_node]
	render :html,'shabi'
end
get :test do
  render :test 
end
post :test1 do
logger.info params
logger.info params[:url].class
  store=Store.new
  store.credit_url=params[:url]
  store.save
  end
end
