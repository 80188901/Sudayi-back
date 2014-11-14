Fancyshpv2::Admin.controllers :product_collections do
  get :index do
    @title = "Product_collections"
    @product_collections = ProductCollection.all
    render 'product_collections/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'product_collection')
    @product_collection = ProductCollection.new
    render 'product_collections/new'
  end

  post :create do
    @product_collection = ProductCollection.new(params[:product_collection])
    if @product_collection.save
      @title = pat(:create_title, :model => "product_collection #{@product_collection.id}")
      flash[:success] = pat(:create_success, :model => 'ProductCollection')
      params[:save_and_continue] ? redirect(url(:product_collections, :index)) : redirect(url(:product_collections, :edit, :id => @product_collection.id))
    else
      @title = pat(:create_title, :model => 'product_collection')
      flash.now[:error] = pat(:create_error, :model => 'product_collection')
      render 'product_collections/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "product_collection #{params[:id]}")
    @product_collection = ProductCollection.find(params[:id])
    if @product_collection
      render 'product_collections/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'product_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "product_collection #{params[:id]}")
    @product_collection = ProductCollection.find(params[:id])
    if @product_collection
      if @product_collection.update_attributes(params[:product_collection])
        flash[:success] = pat(:update_success, :model => 'Product_collection', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:product_collections, :index)) :
          redirect(url(:product_collections, :edit, :id => @product_collection.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'product_collection')
        render 'product_collections/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'product_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Product_collections"
    product_collection = ProductCollection.find(params[:id])
    if product_collection
      if product_collection.destroy
        flash[:success] = pat(:delete_success, :model => 'Product_collection', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'product_collection')
      end
      redirect url(:product_collections, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'product_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Product_collections"
    unless params[:product_collection_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'product_collection')
      redirect(url(:product_collections, :index))
    end
    ids = params[:product_collection_ids].split(',').map(&:strip)
    product_collections = ProductCollection.find(ids)
    
    if product_collections.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Product_collections', :ids => "#{ids.to_sentence}")
    end
    redirect url(:product_collections, :index)
  end
end
