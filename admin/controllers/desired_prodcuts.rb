Fancyshpv2::Admin.controllers :desired_prodcuts do
  get :index do
    @title = "Desired_prodcuts"
    @desired_prodcuts = DesiredProdcut.all
    render 'desired_prodcuts/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'desired_prodcut')
    @desired_prodcut = DesiredProdcut.new
    render 'desired_prodcuts/new'
  end

  post :create do
    @desired_prodcut = DesiredProdcut.new(params[:desired_prodcut])
    if @desired_prodcut.save
      @title = pat(:create_title, :model => "desired_prodcut #{@desired_prodcut.id}")
      flash[:success] = pat(:create_success, :model => 'DesiredProdcut')
      params[:save_and_continue] ? redirect(url(:desired_prodcuts, :index)) : redirect(url(:desired_prodcuts, :edit, :id => @desired_prodcut.id))
    else
      @title = pat(:create_title, :model => 'desired_prodcut')
      flash.now[:error] = pat(:create_error, :model => 'desired_prodcut')
      render 'desired_prodcuts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "desired_prodcut #{params[:id]}")
    @desired_prodcut = DesiredProdcut.find(params[:id])
    if @desired_prodcut
      render 'desired_prodcuts/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'desired_prodcut', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "desired_prodcut #{params[:id]}")
    @desired_prodcut = DesiredProdcut.find(params[:id])
    if @desired_prodcut
      if @desired_prodcut.update_attributes(params[:desired_prodcut])
        flash[:success] = pat(:update_success, :model => 'Desired_prodcut', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:desired_prodcuts, :index)) :
          redirect(url(:desired_prodcuts, :edit, :id => @desired_prodcut.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'desired_prodcut')
        render 'desired_prodcuts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'desired_prodcut', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Desired_prodcuts"
    desired_prodcut = DesiredProdcut.find(params[:id])
    if desired_prodcut
      if desired_prodcut.destroy
        flash[:success] = pat(:delete_success, :model => 'Desired_prodcut', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'desired_prodcut')
      end
      redirect url(:desired_prodcuts, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'desired_prodcut', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Desired_prodcuts"
    unless params[:desired_prodcut_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'desired_prodcut')
      redirect(url(:desired_prodcuts, :index))
    end
    ids = params[:desired_prodcut_ids].split(',').map(&:strip)
    desired_prodcuts = DesiredProdcut.find(ids)
    
    if desired_prodcuts.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Desired_prodcuts', :ids => "#{ids.to_sentence}")
    end
    redirect url(:desired_prodcuts, :index)
  end
end
