Fancyshpv2::Admin.controllers :firm_types do
  get :index do
    @title = "Firm_types"
    @firm_types = FirmType.all
    render 'firm_types/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'firm_type')
    @firm_type = FirmType.new
    render 'firm_types/new'
  end

  post :create do
    @firm_type = FirmType.new(params[:firm_type])
    if @firm_type.save
      @title = pat(:create_title, :model => "firm_type #{@firm_type.id}")
      flash[:success] = pat(:create_success, :model => 'FirmType')
      params[:save_and_continue] ? redirect(url(:firm_types, :index)) : redirect(url(:firm_types, :edit, :id => @firm_type.id))
    else
      @title = pat(:create_title, :model => 'firm_type')
      flash.now[:error] = pat(:create_error, :model => 'firm_type')
      render 'firm_types/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "firm_type #{params[:id]}")
    @firm_type = FirmType.find(params[:id])
    if @firm_type
      render 'firm_types/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'firm_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "firm_type #{params[:id]}")
    @firm_type = FirmType.find(params[:id])
    if @firm_type
      if @firm_type.update_attributes(params[:firm_type])
        flash[:success] = pat(:update_success, :model => 'Firm_type', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:firm_types, :index)) :
          redirect(url(:firm_types, :edit, :id => @firm_type.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'firm_type')
        render 'firm_types/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'firm_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Firm_types"
    firm_type = FirmType.find(params[:id])
    if firm_type
      if firm_type.destroy
        flash[:success] = pat(:delete_success, :model => 'Firm_type', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'firm_type')
      end
      redirect url(:firm_types, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'firm_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Firm_types"
    unless params[:firm_type_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'firm_type')
      redirect(url(:firm_types, :index))
    end
    ids = params[:firm_type_ids].split(',').map(&:strip)
    firm_types = FirmType.find(ids)
    
    if firm_types.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Firm_types', :ids => "#{ids.to_sentence}")
    end
    redirect url(:firm_types, :index)
  end
end
