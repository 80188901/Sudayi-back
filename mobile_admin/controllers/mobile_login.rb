Fancyshpv2::MobileAdmin.controllers :mobile_login do
  get :index do
    render('login', :layout => 'mobile_admin') 
  end
  get :get_account do
    if account = Account.authenticate(params[:email], params[:password])
     account.to_json
    elsif Padrino.env == :development && params[:bypass]
      account = Account.first
       account.to_json
    else
       "密码或用户名错误".to_json
    end

  end
end
