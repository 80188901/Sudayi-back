Fancyshpv2::Admin.controllers :streets do
  get :index do
    @title = "Streets"
    @streets = Street.all
    render 'streets/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'street')
    @street = Street.new
    render 'streets/new'
  end

  post :create do
    @street = Street.new(params[:street])
    if @street.save
      @title = pat(:create_title, :model => "street #{@street.id}")
      flash[:success] = pat(:create_success, :model => 'Street')
      params[:save_and_continue] ? redirect(url(:streets, :index)) : redirect(url(:streets, :edit, :id => @street.id))
    else
      @title = pat(:create_title, :model => 'street')
      flash.now[:error] = pat(:create_error, :model => 'street')
      render 'streets/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "street #{params[:id]}")
    @street = Street.find(params[:id])
    if @street
      render 'streets/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'street', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "street #{params[:id]}")
    @street = Street.find(params[:id])
    if @street
      if @street.update_attributes(params[:street])
        flash[:success] = pat(:update_success, :model => 'Street', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:streets, :index)) :
          redirect(url(:streets, :edit, :id => @street.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'street')
        render 'streets/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'street', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Streets"
    street = Street.find(params[:id])
    if street
      if street.destroy
        flash[:success] = pat(:delete_success, :model => 'Street', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'street')
      end
      redirect url(:streets, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'street', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Streets"
    unless params[:street_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'street')
      redirect(url(:streets, :index))
    end
    ids = params[:street_ids].split(',').map(&:strip)
    streets = Street.find(ids)
    
    if streets.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Streets', :ids => "#{ids.to_sentence}")
    end
    redirect url(:streets, :index)
  end
end
