Fancyshpv2::Admin.controllers :firm_infos do
  get :index do
    @title = "Firm_infos"
    @firm_infos = FirmInfo.all
    render 'firm_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'firm_info')
    @firm_info = FirmInfo.new
    render 'firm_infos/new'
  end

  post :create do
    @firm_info = FirmInfo.new(params[:firm_info])
    if @firm_info.save
      @title = pat(:create_title, :model => "firm_info #{@firm_info.id}")
      flash[:success] = pat(:create_success, :model => 'FirmInfo')
      params[:save_and_continue] ? redirect(url(:firm_infos, :index)) : redirect(url(:firm_infos, :edit, :id => @firm_info.id))
    else
      @title = pat(:create_title, :model => 'firm_info')
      flash.now[:error] = pat(:create_error, :model => 'firm_info')
      render 'firm_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "firm_info #{params[:id]}")
    @firm_info = FirmInfo.find(params[:id])
    if @firm_info
      render 'firm_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'firm_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "firm_info #{params[:id]}")
    @firm_info = FirmInfo.find(params[:id])
    if @firm_info
      if @firm_info.update_attributes(params[:firm_info])
        flash[:success] = pat(:update_success, :model => 'Firm_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:firm_infos, :index)) :
          redirect(url(:firm_infos, :edit, :id => @firm_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'firm_info')
        render 'firm_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'firm_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Firm_infos"
    firm_info = FirmInfo.find(params[:id])
    if firm_info
      if firm_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Firm_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'firm_info')
      end
      redirect url(:firm_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'firm_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Firm_infos"
    unless params[:firm_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'firm_info')
      redirect(url(:firm_infos, :index))
    end
    ids = params[:firm_info_ids].split(',').map(&:strip)
    firm_infos = FirmInfo.find(ids)
    
    if firm_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Firm_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:firm_infos, :index)
  end
end
