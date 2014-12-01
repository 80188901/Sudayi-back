Fancyshpv2::MobileAdmin.controllers :mobile_login do
  use Rack::Cors do
  allow do
    # put real origins here
    origins '*'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end	

  get :index do
    render('login', :layout => 'mobile_admin') 
  end

  get :get_account do
    if account = Account.authenticate_mobile(params[:mobile], params[:password])
     account.to_json
    elsif Padrino.env == :development && params[:bypass]
      account = Account.first
       account.to_json
    else
       "密码或手机错误".to_json
    end
  end

  get :create_account do 
    @account = Account.new(:name => params[:user], :mobile => params[:tel], :password => params[:pwd], :admin_type => params[:way])
    if @account.save
       @account.admin_type.to_json
    else
      @account2 = Account.where(:name => params[:user] ).first;
       @account2.name.to_json
    end
  end
end
