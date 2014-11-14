Fancyshpv2::Admin.controllers :wishes do
  get :index do
    @title = "Wishes"
    @wishes = Wish.all
    render 'wishes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'wish')
    @wish = Wish.new
    render 'wishes/new'
  end

  post :create do
    @wish = Wish.new(params[:wish])
    if @wish.save
      @title = pat(:create_title, :model => "wish #{@wish.id}")
      flash[:success] = pat(:create_success, :model => 'Wish')
      params[:save_and_continue] ? redirect(url(:wishes, :index)) : redirect(url(:wishes, :edit, :id => @wish.id))
    else
      @title = pat(:create_title, :model => 'wish')
      flash.now[:error] = pat(:create_error, :model => 'wish')
      render 'wishes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "wish #{params[:id]}")
    @wish = Wish.find(params[:id])
    if @wish
      render 'wishes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'wish', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "wish #{params[:id]}")
    @wish = Wish.find(params[:id])
    if @wish
      if @wish.update_attributes(params[:wish])
        flash[:success] = pat(:update_success, :model => 'Wish', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:wishes, :index)) :
          redirect(url(:wishes, :edit, :id => @wish.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'wish')
        render 'wishes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'wish', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Wishes"
    wish = Wish.find(params[:id])
    if wish
      if wish.destroy
        flash[:success] = pat(:delete_success, :model => 'Wish', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'wish')
      end
      redirect url(:wishes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'wish', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Wishes"
    unless params[:wish_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'wish')
      redirect(url(:wishes, :index))
    end
    ids = params[:wish_ids].split(',').map(&:strip)
    wishes = Wish.find(ids)
    
    if wishes.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Wishes', :ids => "#{ids.to_sentence}")
    end
    redirect url(:wishes, :index)
  end
end
