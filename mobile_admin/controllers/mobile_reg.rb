Fancyshpv2::MobileAdmin.controllers :mobile_reg do
   get :index do
     render('sign_up') 
    end
   post  :create  do
     @account = Account.new(params[:account])
    if @account.save
    	if params[:role] .to_s== 'agency'
    	    render('agency_intro', :layout => 'mobile_admin')
    	elsif params[:role].to_s == 'provider'
    	    render('approve_intro', :layout => 'mobile_admin')
    	else
         redirect :index
    	end
    else
      flash.now[:error] = '提交信息有误'
     redirect_to(url(:mobile_reg, :index))
   end
 end
end
