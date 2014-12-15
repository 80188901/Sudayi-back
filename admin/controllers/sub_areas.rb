Fancyshpv2::Admin.controllers :sub_areas do
  get :index do
    @title = "Sub_areas"
    @sub_areas = SubArea.all
    render 'sub_areas/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'sub_area')
    @sub_area = SubArea.new
    render 'sub_areas/new'
  end

  post :create do
    @sub_area = SubArea.new(params[:sub_area])
    if @sub_area.save
      @title = pat(:create_title, :model => "sub_area #{@sub_area.id}")
      flash[:success] = pat(:create_success, :model => 'SubArea')
      params[:save_and_continue] ? redirect(url(:sub_areas, :index)) : redirect(url(:sub_areas, :edit, :id => @sub_area.id))
    else
      @title = pat(:create_title, :model => 'sub_area')
      flash.now[:error] = pat(:create_error, :model => 'sub_area')
      render 'sub_areas/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "sub_area #{params[:id]}")
    @sub_area = SubArea.find(params[:id])
    if @sub_area
      render 'sub_areas/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'sub_area', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "sub_area #{params[:id]}")
    @sub_area = SubArea.find(params[:id])
    if @sub_area
      if @sub_area.update_attributes(params[:sub_area])
        flash[:success] = pat(:update_success, :model => 'Sub_area', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:sub_areas, :index)) :
          redirect(url(:sub_areas, :edit, :id => @sub_area.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'sub_area')
        render 'sub_areas/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'sub_area', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Sub_areas"
    sub_area = SubArea.find(params[:id])
    if sub_area
      if sub_area.destroy
        flash[:success] = pat(:delete_success, :model => 'Sub_area', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'sub_area')
      end
      redirect url(:sub_areas, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'sub_area', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Sub_areas"
    unless params[:sub_area_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'sub_area')
      redirect(url(:sub_areas, :index))
    end
    ids = params[:sub_area_ids].split(',').map(&:strip)
    sub_areas = SubArea.find(ids)
    
    if sub_areas.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Sub_areas', :ids => "#{ids.to_sentence}")
    end
    redirect url(:sub_areas, :index)
  end
end
