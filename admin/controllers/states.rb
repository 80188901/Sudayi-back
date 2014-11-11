Fancyshpv2::Admin.controllers :states do
  get :index do
    @title = "States"
    @states = State.all
    render 'states/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'state')
    @state = State.new
    render 'states/new'
  end

  post :create do
    @state = State.new(params[:state])
    if @state.save
      @title = pat(:create_title, :model => "state #{@state.id}")
      flash[:success] = pat(:create_success, :model => 'State')
      params[:save_and_continue] ? redirect(url(:states, :index)) : redirect(url(:states, :edit, :id => @state.id))
    else
      @title = pat(:create_title, :model => 'state')
      flash.now[:error] = pat(:create_error, :model => 'state')
      render 'states/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "state #{params[:id]}")
    @state = State.find(params[:id])
    if @state
      render 'states/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'state', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "state #{params[:id]}")
    @state = State.find(params[:id])
    if @state
      if @state.update_attributes(params[:state])
        flash[:success] = pat(:update_success, :model => 'State', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:states, :index)) :
          redirect(url(:states, :edit, :id => @state.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'state')
        render 'states/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'state', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "States"
    state = State.find(params[:id])
    if state
      if state.destroy
        flash[:success] = pat(:delete_success, :model => 'State', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'state')
      end
      redirect url(:states, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'state', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "States"
    unless params[:state_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'state')
      redirect(url(:states, :index))
    end
    ids = params[:state_ids].split(',').map(&:strip)
    states = State.find(ids)
    
    if states.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'States', :ids => "#{ids.to_sentence}")
    end
    redirect url(:states, :index)
  end
end
