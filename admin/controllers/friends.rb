Fancyshpv2::Admin.controllers :friends do
  get :index do
    @title = "Friends"
    @friends = Friend.all
    render 'friends/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'friend')
    @friend = Friend.new
    render 'friends/new'
  end

  post :create do
    @friend = Friend.new(params[:friend])
    if @friend.save
      @title = pat(:create_title, :model => "friend #{@friend.id}")
      flash[:success] = pat(:create_success, :model => 'Friend')
      params[:save_and_continue] ? redirect(url(:friends, :index)) : redirect(url(:friends, :edit, :id => @friend.id))
    else
      @title = pat(:create_title, :model => 'friend')
      flash.now[:error] = pat(:create_error, :model => 'friend')
      render 'friends/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "friend #{params[:id]}")
    @friend = Friend.find(params[:id])
    if @friend
      render 'friends/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'friend', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "friend #{params[:id]}")
    @friend = Friend.find(params[:id])
    if @friend
      if @friend.update_attributes(params[:friend])
        flash[:success] = pat(:update_success, :model => 'Friend', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:friends, :index)) :
          redirect(url(:friends, :edit, :id => @friend.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'friend')
        render 'friends/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'friend', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Friends"
    friend = Friend.find(params[:id])
    if friend
      if friend.destroy
        flash[:success] = pat(:delete_success, :model => 'Friend', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'friend')
      end
      redirect url(:friends, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'friend', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Friends"
    unless params[:friend_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'friend')
      redirect(url(:friends, :index))
    end
    ids = params[:friend_ids].split(',').map(&:strip)
    friends = Friend.find(ids)
    
    if friends.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Friends', :ids => "#{ids.to_sentence}")
    end
    redirect url(:friends, :index)
  end
end
