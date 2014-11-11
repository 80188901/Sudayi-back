Fancyshpv2::Admin.controllers :massages do
  get :index do
    @title = "Massages"
    @massages = Massage.all
    render 'massages/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'massage')
    @massage = Massage.new
    render 'massages/new'
  end

  post :create do
    @massage = Massage.new(params[:massage])
    if @massage.save
      @title = pat(:create_title, :model => "massage #{@massage.id}")
      flash[:success] = pat(:create_success, :model => 'Massage')
      params[:save_and_continue] ? redirect(url(:massages, :index)) : redirect(url(:massages, :edit, :id => @massage.id))
    else
      @title = pat(:create_title, :model => 'massage')
      flash.now[:error] = pat(:create_error, :model => 'massage')
      render 'massages/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "massage #{params[:id]}")
    @massage = Massage.find(params[:id])
    if @massage
      render 'massages/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'massage', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "massage #{params[:id]}")
    @massage = Massage.find(params[:id])
    if @massage
      if @massage.update_attributes(params[:massage])
        flash[:success] = pat(:update_success, :model => 'Massage', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:massages, :index)) :
          redirect(url(:massages, :edit, :id => @massage.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'massage')
        render 'massages/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'massage', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Massages"
    massage = Massage.find(params[:id])
    if massage
      if massage.destroy
        flash[:success] = pat(:delete_success, :model => 'Massage', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'massage')
      end
      redirect url(:massages, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'massage', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Massages"
    unless params[:massage_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'massage')
      redirect(url(:massages, :index))
    end
    ids = params[:massage_ids].split(',').map(&:strip)
    massages = Massage.find(ids)
    
    if massages.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Massages', :ids => "#{ids.to_sentence}")
    end
    redirect url(:massages, :index)
  end
end
