Fancyshpv2::Admin.controllers :areas do
  get :index do
    @title = "Areas"
    @areas = Area.all
    render 'areas/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'area')
    @area = Area.new
    render 'areas/new'
  end

  post :create do
    @area = Area.new(params[:area])
    if @area.save
      @title = pat(:create_title, :model => "area #{@area.id}")
      flash[:success] = pat(:create_success, :model => 'Area')
      params[:save_and_continue] ? redirect(url(:areas, :index)) : redirect(url(:areas, :edit, :id => @area.id))
    else
      @title = pat(:create_title, :model => 'area')
      flash.now[:error] = pat(:create_error, :model => 'area')
      render 'areas/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "area #{params[:id]}")
    @area = Area.find(params[:id])
    if @area
      render 'areas/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'area', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "area #{params[:id]}")
    @area = Area.find(params[:id])
    if @area
      if @area.update_attributes(params[:area])
        flash[:success] = pat(:update_success, :model => 'Area', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:areas, :index)) :
          redirect(url(:areas, :edit, :id => @area.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'area')
        render 'areas/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'area', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Areas"
    area = Area.find(params[:id])
    if area
      if area.destroy
        flash[:success] = pat(:delete_success, :model => 'Area', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'area')
      end
      redirect url(:areas, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'area', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Areas"
    unless params[:area_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'area')
      redirect(url(:areas, :index))
    end
    ids = params[:area_ids].split(',').map(&:strip)
    areas = Area.find(ids)
    
    if areas.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Areas', :ids => "#{ids.to_sentence}")
    end
    redirect url(:areas, :index)
  end
end
