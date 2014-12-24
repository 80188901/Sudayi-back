Fancyshpv2::MetronicAdmin.controllers :view_layout do
  

  get :layout_horizontal_sidebar_menu do 
     @title ="fancyshop管理系统----垂直边栏以及水平边栏布局"
    render( 'view_layout/horizontal_sidebar_menu.erb',  :layout => :layout_horizontal_sidebar_menu)
  end
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
  

end
