Fancyshpv2::Admin.controllers :credit_infos do
  get :index do
    @title = "Credit_infos"
    @credit_infos = CreditInfo.all
    render 'credit_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'credit_info')
    @credit_info = CreditInfo.new
    render 'credit_infos/new'
  end

  post :create do
    @credit_info = CreditInfo.new(params[:credit_info])
    if @credit_info.save
      @title = pat(:create_title, :model => "credit_info #{@credit_info.id}")
      flash[:success] = pat(:create_success, :model => 'CreditInfo')
      params[:save_and_continue] ? redirect(url(:credit_infos, :index)) : redirect(url(:credit_infos, :edit, :id => @credit_info.id))
    else
      @title = pat(:create_title, :model => 'credit_info')
      flash.now[:error] = pat(:create_error, :model => 'credit_info')
      render 'credit_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "credit_info #{params[:id]}")
    @credit_info = CreditInfo.find(params[:id])
    if @credit_info
      render 'credit_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'credit_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "credit_info #{params[:id]}")
    @credit_info = CreditInfo.find(params[:id])
    if @credit_info
      if @credit_info.update_attributes(params[:credit_info])
        flash[:success] = pat(:update_success, :model => 'Credit_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:credit_infos, :index)) :
          redirect(url(:credit_infos, :edit, :id => @credit_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'credit_info')
        render 'credit_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'credit_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Credit_infos"
    credit_info = CreditInfo.find(params[:id])
    if credit_info
      if credit_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Credit_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'credit_info')
      end
      redirect url(:credit_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'credit_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Credit_infos"
    unless params[:credit_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'credit_info')
      redirect(url(:credit_infos, :index))
    end
    ids = params[:credit_info_ids].split(',').map(&:strip)
    credit_infos = CreditInfo.find(ids)
    
    if credit_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Credit_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:credit_infos, :index)
  end
end
