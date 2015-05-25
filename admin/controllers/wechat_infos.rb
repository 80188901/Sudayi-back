Fancyshpv2::Admin.controllers :wechat_infos do
  get :index do
    @title = "Wechat_infos"
    @wechat_infos = WechatInfo.all
    render 'wechat_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'wechat_info')
    @wechat_info = WechatInfo.new
    render 'wechat_infos/new'
  end

  post :create do
    @wechat_info = WechatInfo.new(params[:wechat_info])
    if @wechat_info.save
      @title = pat(:create_title, :model => "wechat_info #{@wechat_info.id}")
      flash[:success] = pat(:create_success, :model => 'WechatInfo')
      params[:save_and_continue] ? redirect(url(:wechat_infos, :index)) : redirect(url(:wechat_infos, :edit, :id => @wechat_info.id))
    else
      @title = pat(:create_title, :model => 'wechat_info')
      flash.now[:error] = pat(:create_error, :model => 'wechat_info')
      render 'wechat_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "wechat_info #{params[:id]}")
    @wechat_info = WechatInfo.find(params[:id])
    if @wechat_info
      render 'wechat_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'wechat_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "wechat_info #{params[:id]}")
    @wechat_info = WechatInfo.find(params[:id])
    if @wechat_info
      if @wechat_info.update_attributes(params[:wechat_info])
        flash[:success] = pat(:update_success, :model => 'Wechat_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:wechat_infos, :index)) :
          redirect(url(:wechat_infos, :edit, :id => @wechat_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'wechat_info')
        render 'wechat_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'wechat_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Wechat_infos"
    wechat_info = WechatInfo.find(params[:id])
    if wechat_info
      if wechat_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Wechat_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'wechat_info')
      end
      redirect url(:wechat_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'wechat_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Wechat_infos"
    unless params[:wechat_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'wechat_info')
      redirect(url(:wechat_infos, :index))
    end
    ids = params[:wechat_info_ids].split(',').map(&:strip)
    wechat_infos = WechatInfo.find(ids)
    
    if wechat_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Wechat_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:wechat_infos, :index)
  end
end
