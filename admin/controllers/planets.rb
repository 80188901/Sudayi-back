Fancyshpv2::Admin.controllers :planets do
  get :index do
    @title = "Planets"
    @planets = Planet.all
    render 'planets/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'planet')
    @planet = Planet.new
    render 'planets/new'
  end

  post :create do
    @planet = Planet.new(params[:planet])
    if @planet.save
      @title = pat(:create_title, :model => "planet #{@planet.id}")
      flash[:success] = pat(:create_success, :model => 'Planet')
      params[:save_and_continue] ? redirect(url(:planets, :index)) : redirect(url(:planets, :edit, :id => @planet.id))
    else
      @title = pat(:create_title, :model => 'planet')
      flash.now[:error] = pat(:create_error, :model => 'planet')
      render 'planets/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "planet #{params[:id]}")
    @planet = Planet.find(params[:id])
    if @planet
      render 'planets/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'planet', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "planet #{params[:id]}")
    @planet = Planet.find(params[:id])
    if @planet
      if @planet.update_attributes(params[:planet])
        flash[:success] = pat(:update_success, :model => 'Planet', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:planets, :index)) :
          redirect(url(:planets, :edit, :id => @planet.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'planet')
        render 'planets/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'planet', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Planets"
    planet = Planet.find(params[:id])
    if planet
      if planet.destroy
        flash[:success] = pat(:delete_success, :model => 'Planet', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'planet')
      end
      redirect url(:planets, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'planet', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Planets"
    unless params[:planet_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'planet')
      redirect(url(:planets, :index))
    end
    ids = params[:planet_ids].split(',').map(&:strip)
    planets = Planet.find(ids)
    
    if planets.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Planets', :ids => "#{ids.to_sentence}")
    end
    redirect url(:planets, :index)
  end
end
