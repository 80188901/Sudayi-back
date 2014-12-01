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

  get :judge_same_username do
    @account =Account.where(:name => params[:username]).first
    if @account
       0.to_json
   else
      1.to_json
   end
  end

    get :judge_same_mobile do
    @account =Account.where(:mobile => params[:mobile]).first
    if @account
       0.to_json
   else
      1.to_json
   end
  end

   get :judge_same_email do
    @account =Account.where(:email => params[:email]).first
    if @account
      0.to_json
    else
      1.to_json
   end
 end

  get :create_account do 
    @account = Account.new(:role=>'admin' ,:name => params[:user], :mobile => params[:tel], :password => params[:pwd], :admin_type => params[:way], :email => params[:email])
    if @account.save
       @account.admin_type.to_json
    else
      '保存未成功'.to_json
    end
  end
end
