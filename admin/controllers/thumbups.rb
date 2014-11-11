Fancyshpv2::Admin.controllers :thumbups do
  get :index do
    @title = "Thumbups"
    @thumbups = Thumbup.all
    render 'thumbups/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'thumbup')
    @thumbup = Thumbup.new
    render 'thumbups/new'
  end

  post :create do
    @thumbup = Thumbup.new(params[:thumbup])
    if @thumbup.save
      @title = pat(:create_title, :model => "thumbup #{@thumbup.id}")
      flash[:success] = pat(:create_success, :model => 'Thumbup')
      params[:save_and_continue] ? redirect(url(:thumbups, :index)) : redirect(url(:thumbups, :edit, :id => @thumbup.id))
    else
      @title = pat(:create_title, :model => 'thumbup')
      flash.now[:error] = pat(:create_error, :model => 'thumbup')
      render 'thumbups/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "thumbup #{params[:id]}")
    @thumbup = Thumbup.find(params[:id])
    if @thumbup
      render 'thumbups/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'thumbup', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "thumbup #{params[:id]}")
    @thumbup = Thumbup.find(params[:id])
    if @thumbup
      if @thumbup.update_attributes(params[:thumbup])
        flash[:success] = pat(:update_success, :model => 'Thumbup', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:thumbups, :index)) :
          redirect(url(:thumbups, :edit, :id => @thumbup.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'thumbup')
        render 'thumbups/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'thumbup', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Thumbups"
    thumbup = Thumbup.find(params[:id])
    if thumbup
      if thumbup.destroy
        flash[:success] = pat(:delete_success, :model => 'Thumbup', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'thumbup')
      end
      redirect url(:thumbups, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'thumbup', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Thumbups"
    unless params[:thumbup_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'thumbup')
      redirect(url(:thumbups, :index))
    end
    ids = params[:thumbup_ids].split(',').map(&:strip)
    thumbups = Thumbup.find(ids)
    
    if thumbups.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Thumbups', :ids => "#{ids.to_sentence}")
    end
    redirect url(:thumbups, :index)
  end
end
