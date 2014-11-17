Fancyshpv2::MobileAdmin.controllers :mobile_reg do
   get :index do
     render('sign_up') 
    end
   post  :create  do
      render('agency_intro', :layout => 'mobile_admin')
   end
end
