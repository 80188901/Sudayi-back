Fancyshpv2::Admin.controllers :account_collections do
  get :index do
    @title = "Account_collections"
    @account_collections = AccountCollection.all
    render 'account_collections/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'account_collection')
    @account_collection = AccountCollection.new
    render 'account_collections/new'
  end

  post :create do
    @account_collection = AccountCollection.new(params[:account_collection])
    if @account_collection.save
      @title = pat(:create_title, :model => "account_collection #{@account_collection.id}")
      flash[:success] = pat(:create_success, :model => 'AccountCollection')
      params[:save_and_continue] ? redirect(url(:account_collections, :index)) : redirect(url(:account_collections, :edit, :id => @account_collection.id))
    else
      @title = pat(:create_title, :model => 'account_collection')
      flash.now[:error] = pat(:create_error, :model => 'account_collection')
      render 'account_collections/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "account_collection #{params[:id]}")
    @account_collection = AccountCollection.find(params[:id])
    if @account_collection
      render 'account_collections/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'account_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "account_collection #{params[:id]}")
    @account_collection = AccountCollection.find(params[:id])
    if @account_collection
      if @account_collection.update_attributes(params[:account_collection])
        flash[:success] = pat(:update_success, :model => 'Account_collection', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:account_collections, :index)) :
          redirect(url(:account_collections, :edit, :id => @account_collection.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'account_collection')
        render 'account_collections/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'account_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Account_collections"
    account_collection = AccountCollection.find(params[:id])
    if account_collection
      if account_collection.destroy
        flash[:success] = pat(:delete_success, :model => 'Account_collection', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'account_collection')
      end
      redirect url(:account_collections, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'account_collection', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Account_collections"
    unless params[:account_collection_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'account_collection')
      redirect(url(:account_collections, :index))
    end
    ids = params[:account_collection_ids].split(',').map(&:strip)
    account_collections = AccountCollection.find(ids)
    
    if account_collections.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Account_collections', :ids => "#{ids.to_sentence}")
    end
    redirect url(:account_collections, :index)
  end
end
