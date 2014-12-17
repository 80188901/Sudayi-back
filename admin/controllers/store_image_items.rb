Fancyshpv2::Admin.controllers :store_image_items do
  get :index do
    @title = "Store_image_items"
    @store_image_items = StoreImageItem.all
    render 'store_image_items/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'store_image_item')
    @store_image_item = StoreImageItem.new
    render 'store_image_items/new'
  end

  post :create do
    @store_image_item = StoreImageItem.new(params[:store_image_item])
    if @store_image_item.save
      @title = pat(:create_title, :model => "store_image_item #{@store_image_item.id}")
      flash[:success] = pat(:create_success, :model => 'StoreImageItem')
      params[:save_and_continue] ? redirect(url(:store_image_items, :index)) : redirect(url(:store_image_items, :edit, :id => @store_image_item.id))
    else
      @title = pat(:create_title, :model => 'store_image_item')
      flash.now[:error] = pat(:create_error, :model => 'store_image_item')
      render 'store_image_items/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "store_image_item #{params[:id]}")
    @store_image_item = StoreImageItem.find(params[:id])
    if @store_image_item
      render 'store_image_items/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'store_image_item', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "store_image_item #{params[:id]}")
    @store_image_item = StoreImageItem.find(params[:id])
    if @store_image_item
      if @store_image_item.update_attributes(params[:store_image_item])
        flash[:success] = pat(:update_success, :model => 'Store_image_item', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:store_image_items, :index)) :
          redirect(url(:store_image_items, :edit, :id => @store_image_item.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'store_image_item')
        render 'store_image_items/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'store_image_item', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Store_image_items"
    store_image_item = StoreImageItem.find(params[:id])
    if store_image_item
      if store_image_item.destroy
        flash[:success] = pat(:delete_success, :model => 'Store_image_item', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'store_image_item')
      end
      redirect url(:store_image_items, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'store_image_item', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Store_image_items"
    unless params[:store_image_item_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'store_image_item')
      redirect(url(:store_image_items, :index))
    end
    ids = params[:store_image_item_ids].split(',').map(&:strip)
    store_image_items = StoreImageItem.find(ids)
    
    if store_image_items.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Store_image_items', :ids => "#{ids.to_sentence}")
    end
    redirect url(:store_image_items, :index)
  end
end
