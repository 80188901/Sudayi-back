Fancyshpv2::Admin.controllers :buildings do
  get :index do
    @title = "Buildings"
    @buildings = Building.all
    render 'buildings/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'building')
    @building = Building.new
    render 'buildings/new'
  end

  post :create do
    @building = Building.new(params[:building])
    if @building.save
      @title = pat(:create_title, :model => "building #{@building.id}")
      flash[:success] = pat(:create_success, :model => 'Building')
      params[:save_and_continue] ? redirect(url(:buildings, :index)) : redirect(url(:buildings, :edit, :id => @building.id))
    else
      @title = pat(:create_title, :model => 'building')
      flash.now[:error] = pat(:create_error, :model => 'building')
      render 'buildings/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "building #{params[:id]}")
    @building = Building.find(params[:id])
    if @building
      render 'buildings/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'building', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "building #{params[:id]}")
    @building = Building.find(params[:id])
    if @building
      if @building.update_attributes(params[:building])
        flash[:success] = pat(:update_success, :model => 'Building', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:buildings, :index)) :
          redirect(url(:buildings, :edit, :id => @building.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'building')
        render 'buildings/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'building', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Buildings"
    building = Building.find(params[:id])
    if building
      if building.destroy
        flash[:success] = pat(:delete_success, :model => 'Building', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'building')
      end
      redirect url(:buildings, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'building', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Buildings"
    unless params[:building_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'building')
      redirect(url(:buildings, :index))
    end
    ids = params[:building_ids].split(',').map(&:strip)
    buildings = Building.find(ids)
    
    if buildings.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Buildings', :ids => "#{ids.to_sentence}")
    end
    redirect url(:buildings, :index)
  end
end
