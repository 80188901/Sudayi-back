Fancyshpv2::Admin.controllers :store_addresses do
  get :index do
    @title = "Store_addresses"
    @store_addresses = StoreAddress.all
    render 'store_addresses/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'store_address')
    @store_address = StoreAddress.new
    render 'store_addresses/new'
  end

  post :create do
    @store_address = StoreAddress.new(params[:store_address])
    if @store_address.save
      @title = pat(:create_title, :model => "store_address #{@store_address.id}")
      flash[:success] = pat(:create_success, :model => 'StoreAddress')
      params[:save_and_continue] ? redirect(url(:store_addresses, :index)) : redirect(url(:store_addresses, :edit, :id => @store_address.id))
    else
      @title = pat(:create_title, :model => 'store_address')
      flash.now[:error] = pat(:create_error, :model => 'store_address')
      render 'store_addresses/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "store_address #{params[:id]}")
    @store_address = StoreAddress.find(params[:id])
    if @store_address
      render 'store_addresses/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'store_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "store_address #{params[:id]}")
    @store_address = StoreAddress.find(params[:id])
    if @store_address
      if @store_address.update_attributes(params[:store_address])
        flash[:success] = pat(:update_success, :model => 'Store_address', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:store_addresses, :index)) :
          redirect(url(:store_addresses, :edit, :id => @store_address.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'store_address')
        render 'store_addresses/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'store_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Store_addresses"
    store_address = StoreAddress.find(params[:id])
    if store_address
      if store_address.destroy
        flash[:success] = pat(:delete_success, :model => 'Store_address', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'store_address')
      end
      redirect url(:store_addresses, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'store_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Store_addresses"
    unless params[:store_address_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'store_address')
      redirect(url(:store_addresses, :index))
    end
    ids = params[:store_address_ids].split(',').map(&:strip)
    store_addresses = StoreAddress.find(ids)
    
    if store_addresses.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Store_addresses', :ids => "#{ids.to_sentence}")
    end
    redirect url(:store_addresses, :index)
  end
end
