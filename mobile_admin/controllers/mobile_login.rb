Fancyshpv2::MobileAdmin.controllers :mobile_login do
  use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end

end	

  get :index do
    render('login', :layout => 'mobile_admin') 
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
    @account = Account.new(:password_confirmation => params[:apwd], :role=>'admin', :name => params[:user], :mobile => params[:tel], :password => params[:pwd], :admin_type => params[:way], :email => params[:email])
    if @account.save
       @account.to_json
    else
      '保存未成功'.to_json
    end
  end

  get :find_account do
    @account =Account.where(:name => params[:username]).first;
    @account.to_json
  end

  post :update_account_url, :csrf_protection => false  do
    @account =Account.where(:_id => params[:userid]).first;
    @firm_type = FirmType.where(:name => '个人').first;
    if @account
       url = params[:url]
       if url
          @credit_info = CreditInfo.new(:name => params[:p_principal], :email => params[:p_email], :card_id => params[:p_iden], :province_id => params[:p_province], :city_id => params[:p_city], :area_id => params[:p_area], :url => url, :firm_type => @firm_type._id)
           @state=State.all.first
         @credit_info.state = @state._id
         @credit_info.save
         @account.credit_info_id = @credit_info._id
         @account.save
         @credit_info.to_json
       else
        @credit_info = CreditInfo.new(:name => params[:p_principal], :email => params[:p_email], :card_id => params[:p_iden], :province_id => params[:p_province], :city_id => params[:p_city], :area_id => params[:p_area])
         @credit_info.state = @state._id
         @credit_info.save
         @account.credit_info_id=@credit_info._id
         @account.save
         @credit_info.to_json
       end
    else
         1.to_json
    end
  end

get :get_firm_type do
 @firm_types =FirmType.all
 @firm_types.to_json
end

 post :insert_url2_to_account_info, :csrf_protection =>false do
  @credit_info = CreditInfo.find(params[:credit_info_id])
  @credit_info.url2 = params[:url2]
  @credit_info.save
  @credit_info.to_json
 end

  post :update_account_2url, :csrf_protection =>false do
    @account =Account.where(:_id => params[:userid]).first;
    if @account
       @state=State.where(:code => 0).first
       url = params[:url]
       url2 = params[:url2]
       if url and url2
          @credit_info = CreditInfo.new(:name => params[:p_principal], :email => params[:p_email], :card_id => params[:p_iden], :province_id => params[:p_province], :city_id => params[:p_city], :area_id => params[:p_area], :url => url,:url2 => url2, :firm_type => params[:p_type])
         @credit_info.state = @state._id
         @credit_info.save
         @account.credit_info_id=@credit_info._id
         @account.save
         @credit_info.to_json
       else
        @credit_info = CreditInfo.new(:name => params[:p_principal], :email => params[:p_email], :card_id => params[:p_iden], :province_id => params[:p_province], :city_id => params[:p_city], :area_id => params[:p_area])
         @credit_info.state = @state._id
         @credit_info.save
         @account.credit_info_id=@credit_info._id
         @account.save
         @credit_info.to_json
       end
    else
         1.to_json
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
