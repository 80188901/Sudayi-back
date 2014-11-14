Fancyshpv2::Admin.controllers :website_collections do
  get :index do
    @title = "Website_collections"
    @website_collections = WebsiteCollection.all
    render 'website_collections/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'website_collection')
    @website_collection = WebsiteCollection.new
    render 'website_collections/new'
  end

  post :create do
    @website_collection = WebsiteCollection.new(params[:website_collection])
    if @website_collection.save
      @title = pat(:create_title, :model => "website_collection #{@website_collection.id}")
      flash[:success] = pat(:create_success, :model => 'WebsiteCollection')
      params[:save_and_continue] ? redirect(url(:website_collections, :index)) : redirect(url(:website_collections, :edit, :id => @website_collection.id))
    else
      @title = pat(:create_title, :model => 'website_collection')
      flash.now[:error] = pat(:create_error, :model => 'website_collection')
      render 'website_collections/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "website_collection #{params[:id]}")
    @website_collection = WebsiteCollection.find(params[:id])
    if @website_collection
      render 'website_collections/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'website_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "website_collection #{params[:id]}")
    @website_collection = WebsiteCollection.find(params[:id])
    if @website_collection
      if @website_collection.update_attributes(params[:website_collection])
        flash[:success] = pat(:update_success, :model => 'Website_collection', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:website_collections, :index)) :
          redirect(url(:website_collections, :edit, :id => @website_collection.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'website_collection')
        render 'website_collections/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'website_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Website_collections"
    website_collection = WebsiteCollection.find(params[:id])
    if website_collection
      if website_collection.destroy
        flash[:success] = pat(:delete_success, :model => 'Website_collection', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'website_collection')
      end
      redirect url(:website_collections, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'website_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Website_collections"
    unless params[:website_collection_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'website_collection')
      redirect(url(:website_collections, :index))
    end
    ids = params[:website_collection_ids].split(',').map(&:strip)
    website_collections = WebsiteCollection.find(ids)
    
    if website_collections.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Website_collections', :ids => "#{ids.to_sentence}")
    end
    redirect url(:website_collections, :index)
  end
end
