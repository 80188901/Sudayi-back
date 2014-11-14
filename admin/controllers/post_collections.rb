Fancyshpv2::Admin.controllers :post_collections do
  get :index do
    @title = "Post_collections"
    @post_collections = PostCollection.all
    render 'post_collections/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'post_collection')
    @post_collection = PostCollection.new
    render 'post_collections/new'
  end

  post :create do
    @post_collection = PostCollection.new(params[:post_collection])
    if @post_collection.save
      @title = pat(:create_title, :model => "post_collection #{@post_collection.id}")
      flash[:success] = pat(:create_success, :model => 'PostCollection')
      params[:save_and_continue] ? redirect(url(:post_collections, :index)) : redirect(url(:post_collections, :edit, :id => @post_collection.id))
    else
      @title = pat(:create_title, :model => 'post_collection')
      flash.now[:error] = pat(:create_error, :model => 'post_collection')
      render 'post_collections/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "post_collection #{params[:id]}")
    @post_collection = PostCollection.find(params[:id])
    if @post_collection
      render 'post_collections/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'post_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "post_collection #{params[:id]}")
    @post_collection = PostCollection.find(params[:id])
    if @post_collection
      if @post_collection.update_attributes(params[:post_collection])
        flash[:success] = pat(:update_success, :model => 'Post_collection', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:post_collections, :index)) :
          redirect(url(:post_collections, :edit, :id => @post_collection.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'post_collection')
        render 'post_collections/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'post_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Post_collections"
    post_collection = PostCollection.find(params[:id])
    if post_collection
      if post_collection.destroy
        flash[:success] = pat(:delete_success, :model => 'Post_collection', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'post_collection')
      end
      redirect url(:post_collections, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'post_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Post_collections"
    unless params[:post_collection_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'post_collection')
      redirect(url(:post_collections, :index))
    end
    ids = params[:post_collection_ids].split(',').map(&:strip)
    post_collections = PostCollection.find(ids)
    
    if post_collections.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Post_collections', :ids => "#{ids.to_sentence}")
    end
    redirect url(:post_collections, :index)
  end
end
