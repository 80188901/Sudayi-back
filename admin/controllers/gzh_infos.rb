Fancyshpv2::Admin.controllers :gzh_infos do
  get :index do
    @title = "Gzh_infos"
    @gzh_infos = GzhInfo.all
    render 'gzh_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'gzh_info')
    @gzh_info = GzhInfo.new
    render 'gzh_infos/new'
  end

  post :create do
    @gzh_info = GzhInfo.new(params[:gzh_info])
    if @gzh_info.save
      @title = pat(:create_title, :model => "gzh_info #{@gzh_info.id}")
      flash[:success] = pat(:create_success, :model => 'GzhInfo')
      params[:save_and_continue] ? redirect(url(:gzh_infos, :index)) : redirect(url(:gzh_infos, :edit, :id => @gzh_info.id))
    else
      @title = pat(:create_title, :model => 'gzh_info')
      flash.now[:error] = pat(:create_error, :model => 'gzh_info')
      render 'gzh_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "gzh_info #{params[:id]}")
    @gzh_info = GzhInfo.find(params[:id])
    if @gzh_info
      render 'gzh_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'gzh_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "gzh_info #{params[:id]}")
    @gzh_info = GzhInfo.find(params[:id])
    if @gzh_info
      if @gzh_info.update_attributes(params[:gzh_info])
        flash[:success] = pat(:update_success, :model => 'Gzh_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:gzh_infos, :index)) :
          redirect(url(:gzh_infos, :edit, :id => @gzh_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'gzh_info')
        render 'gzh_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'gzh_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Gzh_infos"
    gzh_info = GzhInfo.find(params[:id])
    if gzh_info
      if gzh_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Gzh_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'gzh_info')
      end
      redirect url(:gzh_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'gzh_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Gzh_infos"
    unless params[:gzh_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'gzh_info')
      redirect(url(:gzh_infos, :index))
    end
    ids = params[:gzh_info_ids].split(',').map(&:strip)
    gzh_infos = GzhInfo.find(ids)
    
    if gzh_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Gzh_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:gzh_infos, :index)
  end
end
