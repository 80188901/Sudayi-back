Fancyshpv2::MobileAdmin.controllers :mobile_login do
  get :index do
    render('login', :layout => 'mobile_admin') 
  end
end
