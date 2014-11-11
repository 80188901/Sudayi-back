Fancyshpv2::Admin.controllers :area_distances do
  get :index do
    @title = "Area_distances"
    @area_distances = AreaDistance.all
    render 'area_distances/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'area_distance')
    @area_distance = AreaDistance.new
    render 'area_distances/new'
  end

  post :create do
    @area_distance = AreaDistance.new(params[:area_distance])
    if @area_distance.save
      @title = pat(:create_title, :model => "area_distance #{@area_distance.id}")
      flash[:success] = pat(:create_success, :model => 'AreaDistance')
      params[:save_and_continue] ? redirect(url(:area_distances, :index)) : redirect(url(:area_distances, :edit, :id => @area_distance.id))
    else
      @title = pat(:create_title, :model => 'area_distance')
      flash.now[:error] = pat(:create_error, :model => 'area_distance')
      render 'area_distances/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "area_distance #{params[:id]}")
    @area_distance = AreaDistance.find(params[:id])
    if @area_distance
      render 'area_distances/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'area_distance', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "area_distance #{params[:id]}")
    @area_distance = AreaDistance.find(params[:id])
    if @area_distance
      if @area_distance.update_attributes(params[:area_distance])
        flash[:success] = pat(:update_success, :model => 'Area_distance', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:area_distances, :index)) :
          redirect(url(:area_distances, :edit, :id => @area_distance.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'area_distance')
        render 'area_distances/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'area_distance', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Area_distances"
    area_distance = AreaDistance.find(params[:id])
    if area_distance
      if area_distance.destroy
        flash[:success] = pat(:delete_success, :model => 'Area_distance', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'area_distance')
      end
      redirect url(:area_distances, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'area_distance', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Area_distances"
    unless params[:area_distance_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'area_distance')
      redirect(url(:area_distances, :index))
    end
    ids = params[:area_distance_ids].split(',').map(&:strip)
    area_distances = AreaDistance.find(ids)
    
    if area_distances.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Area_distances', :ids => "#{ids.to_sentence}")
    end
    redirect url(:area_distances, :index)
  end
end
