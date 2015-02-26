Fancyshpv2::Admin.controllers :settings do
  get :index do
    @title = "Settings"
    @settings = Setting.all
    render 'settings/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'setting')
    @setting = Setting.new
    render 'settings/new'
  end

  post :create do
    @setting = Setting.new(params[:setting])
    if @setting.save
      @title = pat(:create_title, :model => "setting #{@setting.id}")
      flash[:success] = pat(:create_success, :model => 'Setting')
      params[:save_and_continue] ? redirect(url(:settings, :index)) : redirect(url(:settings, :edit, :id => @setting.id))
    else
      @title = pat(:create_title, :model => 'setting')
      flash.now[:error] = pat(:create_error, :model => 'setting')
      render 'settings/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "setting #{params[:id]}")
    @setting = Setting.find(params[:id])
    if @setting
      render 'settings/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'setting', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "setting #{params[:id]}")
    @setting = Setting.find(params[:id])
    if @setting
      if @setting.update_attributes(params[:setting])
        flash[:success] = pat(:update_success, :model => 'Setting', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:settings, :index)) :
          redirect(url(:settings, :edit, :id => @setting.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'setting')
        render 'settings/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'setting', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Settings"
    setting = Setting.find(params[:id])
    if setting
      if setting.destroy
        flash[:success] = pat(:delete_success, :model => 'Setting', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'setting')
      end
      redirect url(:settings, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'setting', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Settings"
    unless params[:setting_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'setting')
      redirect(url(:settings, :index))
    end
    ids = params[:setting_ids].split(',').map(&:strip)
    settings = Setting.find(ids)
    
    if settings.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Settings', :ids => "#{ids.to_sentence}")
    end
    redirect url(:settings, :index)
  end
end
