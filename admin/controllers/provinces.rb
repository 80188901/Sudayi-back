Fancyshpv2::Admin.controllers :provinces do
  get :index do
    @title = "Provinces"
    @provinces = Province.all
    render 'provinces/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'province')
    @province = Province.new
    render 'provinces/new'
  end

  post :create do
    @province = Province.new(params[:province])
    if @province.save
      @title = pat(:create_title, :model => "province #{@province.id}")
      flash[:success] = pat(:create_success, :model => 'Province')
      params[:save_and_continue] ? redirect(url(:provinces, :index)) : redirect(url(:provinces, :edit, :id => @province.id))
    else
      @title = pat(:create_title, :model => 'province')
      flash.now[:error] = pat(:create_error, :model => 'province')
      render 'provinces/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "province #{params[:id]}")
    @province = Province.find(params[:id])
    if @province
      render 'provinces/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'province', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "province #{params[:id]}")
    @province = Province.find(params[:id])
    if @province
      if @province.update_attributes(params[:province])
        flash[:success] = pat(:update_success, :model => 'Province', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:provinces, :index)) :
          redirect(url(:provinces, :edit, :id => @province.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'province')
        render 'provinces/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'province', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Provinces"
    province = Province.find(params[:id])
    if province
      if province.destroy
        flash[:success] = pat(:delete_success, :model => 'Province', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'province')
      end
      redirect url(:provinces, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'province', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Provinces"
    unless params[:province_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'province')
      redirect(url(:provinces, :index))
    end
    ids = params[:province_ids].split(',').map(&:strip)
    provinces = Province.find(ids)
    
    if provinces.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Provinces', :ids => "#{ids.to_sentence}")
    end
    redirect url(:provinces, :index)
  end

  get :get_country_select do
    if params[:planet_id]!=''
      @countries = Country.where(:planet_id =>Planet.find(params[:planet_id]).id).to_json
    else
      nil.to_json
    end
  end
 
end
