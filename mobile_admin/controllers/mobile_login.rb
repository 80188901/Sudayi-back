Fancyshpv2::MobileAdmin.controllers :mobile_login do
  use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end

end	


get :code_image do
  
  session[:noisy_image]=NoisyImage.new(4)  
  session[:code]=session[:noisy_image].code 
  image=session[:noisy_image].image  
  image
end

  get :get_account do
     @account = Account.authenticate_mobile(params[:mobile], params[:password])
     if @account
         @account.to_json
    else
       "密码或手机 错误".to_json
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
       'false,该手机号码已被注册'.to_json
   else
     if params[:mobile].length!=11
	"false,手机号码有误".to_json
     else
      ("true,"+params[:mobile]).to_json
     end
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

  post :create_account, :csrf_protection =>false do
  if params[:area_id]
    @account=Account.new(:password_confirmation => params[:apwd], :role=>'gongyingshang',  :mobile => params[:tel], :password => params[:pwd])
    area=Area.find(params[:area_id])
    @account.create_address(area_id:area._id,city_id:area.city_id,province_id:area.province_id,country_id:area.country_id,planet_id:area.planet_id)
    if @account.save
      @account.to_json
    else
              "注册失败".to_json
    end  
   else
	"请填写地址".to_json
   end
  end

  get :is_authentication do
	if params[:user_id] and params[:user_id]!='null'
          account=Account.find(params[:user_id])
	  result='未认证'
          if account.credit_info
	     result=account.credit_info.name
          end
	  if firm_info=FirmInfo.where(account_id:params[:user_id]).first
	     result=firm_info.legal_person
	  end	
          render:html,result.to_json	
	end
  end

  get :find_account do
    @account =Account.where(:name => params[:username]).first;
    @account.to_json
  end


get :get_firm_type do
 @firm_types =FirmType.all
 @firm_types.to_json
end

post :update_account_info, :csrf_protection =>false do
  if params[:user_id] and params[:url1] and params[:url2] and params[:url3] and params[:name] and params[:card_number] and params[:address]
    @account =Account.where(:_id=>params[:user_id]).first
    if @account
      if !CreditInfo.where(card_id:params[:card_number]).first 
       @state=State.where(:code => 0).first
       url1 = params[:url1]
       url2 = params[:url2]
       url3=params[:url3]
       @credit_info = CreditInfo.new(:name => params[:name], :card_id => params[:card_number] ,:url => url1,:url2 => url2,:url3=>url3)
       @credit_info.state=@state
       @credit_info.save
       @account.credit_info_id=@credit_info._id
       detail=Detail.create(name:params[:address])
       @account.address.detail_id=detail._id
       @account.address.save
       @account.save
       @credit_info.to_json
      else
	"该身份证号已被注册".to_json
      end
    else
         "账户不存在".to_json
    end
  else
     "请填写完整的信息".to_json
  end
end


post :update_firm_info,:csrf_protection=>false do
   if params[:name] and params[:user_id] and params[:legal_person] and params[:number] and params[:code] and params[:url1] and params[:url2] and params[:url3] and params[:address]
    @account =Account.find(params[:user_id])
    if @account
       if FirmInfo.where(firm_name:params[:name]).first or FirmInfo.where(business_license_number:params[:number]).first or FirmInfo.where(org_code:params[:code]).first
		"该公司信息已被注册".to_json
       else
	@state=State.where(:code => 0).first
       # firm_type=FirmType.where(name:params[:firm_type]).first
       url1 = params[:url1]
       url2 = params[:url2]
        url3=params[:url3]
    	@firm_info=FirmInfo.new(firm_name:params[:name],legal_person:params[:legal_person],business_license_number:params[:number],org_code:params[:code],url:url1,url2:url2,url3:url3)	
	 @firm_info.state=@state
	 @firm_info.account=@account
	 detail=Detail.create(name:params[:address])
	 @firm_info.address=Address.create
	 @firm_info.address.detail=detail
         @firm_info.address.save
	# @firm_info.firm_type=firm_type
         @firm_info.save
         @account.save
         @firm_info.to_json
        end
    else
	 "账号不存在".to_json
    end
   else
	"请完整地填写信息".to_json
   end
end

  get :get_account_credit do
    @account =Account.find(params[:userid]);
    @credit_info = CreditInfo.find(@account.credit_info_id)
    @credit_info.to_json
  end
   
   get :get_province_in_china do
     #@china = Country.where(:name => '中国').first
     @provinces = Province.all
     @provinces.to_json
   end

   get :get_province_id do
      @cities = City.where(:province_id => params[:province_id])
      @cities.to_json
   end

   get :get_city_id do
      @areas = Area.where(:city_id => params[:city_id]);
      @areas.to_json
    end

    get :get_province_name do
      Province.find(params[:province_id]).to_json
    end
    get :get_city_name do
      City.find(params[:city_id]).to_json
    end
    get :get_area_name do
      Area.find(params[:area_id]).to_json
    end

    get :get_state_name do
      State.find(params[:state_id]).to_json
    end

    get :get_firm_type_name do
      FirmType.find(params[:firm_type_id]).to_json
    end
end
