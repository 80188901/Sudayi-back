Fancyshpv2::Admin.controllers :product_stores do
  get :index do
    @title = "Product_stores"
    @product_stores = ProductStore.all
    render 'product_stores/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'product_store')
    @product_store = ProductStore.new
    render 'product_stores/new'
  end

  post :create do
    @product_store = ProductStore.new(params[:product_store])
    if @product_store.save
      @title = pat(:create_title, :model => "product_store #{@product_store.id}")
      flash[:success] = pat(:create_success, :model => 'ProductStore')
      params[:save_and_continue] ? redirect(url(:product_stores, :index)) : redirect(url(:product_stores, :edit, :id => @product_store.id))
    else
      @title = pat(:create_title, :model => 'product_store')
      flash.now[:error] = pat(:create_error, :model => 'product_store')
      render 'product_stores/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "product_store #{params[:id]}")
    @product_store = ProductStore.find(params[:id])
    if @product_store
      render 'product_stores/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'product_store', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "product_store #{params[:id]}")
    @product_store = ProductStore.find(params[:id])
    if @product_store
      if @product_store.update_attributes(params[:product_store])
        flash[:success] = pat(:update_success, :model => 'Product_store', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:product_stores, :index)) :
          redirect(url(:product_stores, :edit, :id => @product_store.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'product_store')
        render 'product_stores/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'product_store', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Product_stores"
    product_store = ProductStore.find(params[:id])
    if product_store
      if product_store.destroy
        flash[:success] = pat(:delete_success, :model => 'Product_store', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'product_store')
      end
      redirect url(:product_stores, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'product_store', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Product_stores"
    unless params[:product_store_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'product_store')
      redirect(url(:product_stores, :index))
    end
    ids = params[:product_store_ids].split(',').map(&:strip)
    product_stores = ProductStore.find(ids)
    
    if product_stores.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Product_stores', :ids => "#{ids.to_sentence}")
    end
    redirect url(:product_stores, :index)
  end
end
