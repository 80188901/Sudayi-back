Fancyshpv2::Admin.controllers :city_distances do
  get :index do
    @title = "City_distances"
    @city_distances = CityDistance.all
    render 'city_distances/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'city_distance')
    @city_distance = CityDistance.new
    render 'city_distances/new'
  end

  post :create do
    @city_distance = CityDistance.new(params[:city_distance])
    if @city_distance.save
      @title = pat(:create_title, :model => "city_distance #{@city_distance.id}")
      flash[:success] = pat(:create_success, :model => 'CityDistance')
      params[:save_and_continue] ? redirect(url(:city_distances, :index)) : redirect(url(:city_distances, :edit, :id => @city_distance.id))
    else
      @title = pat(:create_title, :model => 'city_distance')
      flash.now[:error] = pat(:create_error, :model => 'city_distance')
      render 'city_distances/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "city_distance #{params[:id]}")
    @city_distance = CityDistance.find(params[:id])
    if @city_distance
      render 'city_distances/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'city_distance', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "city_distance #{params[:id]}")
    @city_distance = CityDistance.find(params[:id])
    if @city_distance
      if @city_distance.update_attributes(params[:city_distance])
        flash[:success] = pat(:update_success, :model => 'City_distance', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:city_distances, :index)) :
          redirect(url(:city_distances, :edit, :id => @city_distance.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'city_distance')
        render 'city_distances/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'city_distance', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "City_distances"
    city_distance = CityDistance.find(params[:id])
    if city_distance
      if city_distance.destroy
        flash[:success] = pat(:delete_success, :model => 'City_distance', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'city_distance')
      end
      redirect url(:city_distances, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'city_distance', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "City_distances"
    unless params[:city_distance_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'city_distance')
      redirect(url(:city_distances, :index))
    end
    ids = params[:city_distance_ids].split(',').map(&:strip)
    city_distances = CityDistance.find(ids)
    
    if city_distances.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'City_distances', :ids => "#{ids.to_sentence}")
    end
    redirect url(:city_distances, :index)
  end
end
