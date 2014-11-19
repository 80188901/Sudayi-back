Fancyshpv2::Admin.controllers :statics do
  get :index do
    @title = "Statics"
    @statics = Static.all
    render 'statics/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'static')
    @static = Static.new
    render 'statics/new'
  end

  post :create do
    @static = Static.new(params[:static])
    if @static.save
      @title = pat(:create_title, :model => "static #{@static.id}")
      flash[:success] = pat(:create_success, :model => 'Static')
      params[:save_and_continue] ? redirect(url(:statics, :index)) : redirect(url(:statics, :edit, :id => @static.id))
    else
      @title = pat(:create_title, :model => 'static')
      flash.now[:error] = pat(:create_error, :model => 'static')
      render 'statics/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "static #{params[:id]}")
    @static = Static.find(params[:id])
    if @static
      render 'statics/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'static', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "static #{params[:id]}")
    @static = Static.find(params[:id])
    if @static
      if @static.update_attributes(params[:static])
        flash[:success] = pat(:update_success, :model => 'Static', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:statics, :index)) :
          redirect(url(:statics, :edit, :id => @static.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'static')
        render 'statics/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'static', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Statics"
    static = Static.find(params[:id])
    if static
      if static.destroy
        flash[:success] = pat(:delete_success, :model => 'Static', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'static')
      end
      redirect url(:statics, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'static', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Statics"
    unless params[:static_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'static')
      redirect(url(:statics, :index))
    end
    ids = params[:static_ids].split(',').map(&:strip)
    statics = Static.find(ids)
    
    if statics.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Statics', :ids => "#{ids.to_sentence}")
    end
    redirect url(:statics, :index)
  end
end
