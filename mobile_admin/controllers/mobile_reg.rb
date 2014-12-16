Fancyshpv2::MobileAdmin.controllers :mobile_reg do
   get :index do
     render('sign_up') 
    end
   post  :create  do
     @account = Account.new(params[:account])
    if @account.save
    	if params[:role] .to_s== 'agency'
    	    redirect_to(url(:mobile_reg, :agency_intro ))
    	elsif params[:role].to_s == 'provider'
    	    redirect_to(url(:mobile_reg, :approve_intro ))
    	else
    	     flash.now[:error] = '提交信息有误(没有role)'
                    redirect_to(url(:mobile_reg, :iagency_intro ))
    	end
     else
       flash.now[:error] = '提交信息有误'
       #redirect_to(url(:mobile_reg, :agency_intro ))
    end
   end

   get :agency_intro do
      render('agency_intro', :layout => 'mobile_admin')
   end

   get :approve_intro do
       render('approve_intro', :layout => 'mobile_admin')
   end

end
