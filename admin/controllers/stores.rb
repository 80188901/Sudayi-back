Fancyshpv2::Admin.controllers :stores do
  get :index do
    @title = "Stores"
    @stores = Store.all
    render 'stores/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'store')
    @store = Store.new
    render 'stores/new'
  end

  post :create do
    @store = Store.new(params[:store])
    if @store.save
      @title = pat(:create_title, :model => "store #{@store.id}")
      flash[:success] = pat(:create_success, :model => 'Store')
      params[:save_and_continue] ? redirect(url(:stores, :index)) : redirect(url(:stores, :edit, :id => @store.id))
    else
      @title = pat(:create_title, :model => 'store')
      flash.now[:error] = pat(:create_error, :model => 'store')
      render 'stores/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "store #{params[:id]}")
    @store = Store.find(params[:id])
    if @store
      render 'stores/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'store', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "store #{params[:id]}")
    @store = Store.find(params[:id])
    if @store
      if @store.update_attributes(params[:store])
        flash[:success] = pat(:update_success, :model => 'Store', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:stores, :index)) :
          redirect(url(:stores, :edit, :id => @store.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'store')
        render 'stores/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'store', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Stores"
    store = Store.find(params[:id])
    if store
      if store.destroy
        flash[:success] = pat(:delete_success, :model => 'Store', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'store')
      end
      redirect url(:stores, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'store', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Stores"
    unless params[:store_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'store')
      redirect(url(:stores, :index))
    end
    ids = params[:store_ids].split(',').map(&:strip)
    stores = Store.find(ids)
    
    if stores.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Stores', :ids => "#{ids.to_sentence}")
    end
    redirect url(:stores, :index)
  end
end
