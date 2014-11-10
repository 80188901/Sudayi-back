Fancyshpv2::Admin.controllers :addresses do
  get :index do
    @title = "Addresses"
    @addresses = Address.all
    render 'addresses/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'address')
    @address = Address.new
    render 'addresses/new'
  end

  post :create do
    @address = Address.new(params[:address])
    if @address.save
      @title = pat(:create_title, :model => "address #{@address.id}")
      flash[:success] = pat(:create_success, :model => 'Address')
      params[:save_and_continue] ? redirect(url(:addresses, :index)) : redirect(url(:addresses, :edit, :id => @address.id))
    else
      @title = pat(:create_title, :model => 'address')
      flash.now[:error] = pat(:create_error, :model => 'address')
      render 'addresses/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "address #{params[:id]}")
    @address = Address.find(params[:id])
    if @address
      render 'addresses/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'address', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "address #{params[:id]}")
    @address = Address.find(params[:id])
    if @address
      if @address.update_attributes(params[:address])
        flash[:success] = pat(:update_success, :model => 'Address', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:addresses, :index)) :
          redirect(url(:addresses, :edit, :id => @address.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'address')
        render 'addresses/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Addresses"
    address = Address.find(params[:id])
    if address
      if address.destroy
        flash[:success] = pat(:delete_success, :model => 'Address', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'address')
      end
      redirect url(:addresses, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Addresses"
    unless params[:address_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'address')
      redirect(url(:addresses, :index))
    end
    ids = params[:address_ids].split(',').map(&:strip)
    addresses = Address.find(ids)
    
    if addresses.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Addresses', :ids => "#{ids.to_sentence}")
    end
    redirect url(:addresses, :index)
  end
end
