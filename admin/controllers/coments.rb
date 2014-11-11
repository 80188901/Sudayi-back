Fancyshpv2::Admin.controllers :coments do
  get :index do
    @title = "Coments"
    @coments = Coment.all
    render 'coments/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'coment')
    @coment = Coment.new
    render 'coments/new'
  end

  post :create do
    @coment = Coment.new(params[:coment])
    if @coment.save
      @title = pat(:create_title, :model => "coment #{@coment.id}")
      flash[:success] = pat(:create_success, :model => 'Coment')
      params[:save_and_continue] ? redirect(url(:coments, :index)) : redirect(url(:coments, :edit, :id => @coment.id))
    else
      @title = pat(:create_title, :model => 'coment')
      flash.now[:error] = pat(:create_error, :model => 'coment')
      render 'coments/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "coment #{params[:id]}")
    @coment = Coment.find(params[:id])
    if @coment
      render 'coments/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'coment', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "coment #{params[:id]}")
    @coment = Coment.find(params[:id])
    if @coment
      if @coment.update_attributes(params[:coment])
        flash[:success] = pat(:update_success, :model => 'Coment', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:coments, :index)) :
          redirect(url(:coments, :edit, :id => @coment.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'coment')
        render 'coments/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'coment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Coments"
    coment = Coment.find(params[:id])
    if coment
      if coment.destroy
        flash[:success] = pat(:delete_success, :model => 'Coment', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'coment')
      end
      redirect url(:coments, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'coment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Coments"
    unless params[:coment_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'coment')
      redirect(url(:coments, :index))
    end
    ids = params[:coment_ids].split(',').map(&:strip)
    coments = Coment.find(ids)
    
    if coments.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Coments', :ids => "#{ids.to_sentence}")
    end
    redirect url(:coments, :index)
  end
end
