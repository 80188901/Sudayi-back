Fancyshpv2::Admin.controllers :templetes do
  get :index do
    @title = "Templetes"
    @templetes = Templete.all
    render 'templetes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'templete')
    @templete = Templete.new
    render 'templetes/new'
  end

  post :create do
    @templete = Templete.new(params[:templete])
    if @templete.save
      @title = pat(:create_title, :model => "templete #{@templete.id}")
      flash[:success] = pat(:create_success, :model => 'Templete')
      params[:save_and_continue] ? redirect(url(:templetes, :index)) : redirect(url(:templetes, :edit, :id => @templete.id))
    else
      @title = pat(:create_title, :model => 'templete')
      flash.now[:error] = pat(:create_error, :model => 'templete')
      render 'templetes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "templete #{params[:id]}")
    @templete = Templete.find(params[:id])
    if @templete
      render 'templetes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'templete', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "templete #{params[:id]}")
    @templete = Templete.find(params[:id])
    if @templete
      if @templete.update_attributes(params[:templete])
        flash[:success] = pat(:update_success, :model => 'Templete', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:templetes, :index)) :
          redirect(url(:templetes, :edit, :id => @templete.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'templete')
        render 'templetes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'templete', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Templetes"
    templete = Templete.find(params[:id])
    if templete
      if templete.destroy
        flash[:success] = pat(:delete_success, :model => 'Templete', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'templete')
      end
      redirect url(:templetes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'templete', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Templetes"
    unless params[:templete_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'templete')
      redirect(url(:templetes, :index))
    end
    ids = params[:templete_ids].split(',').map(&:strip)
    templetes = Templete.find(ids)
    
    if templetes.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Templetes', :ids => "#{ids.to_sentence}")
    end
    redirect url(:templetes, :index)
  end
end
