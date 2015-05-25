Fancyshpv2::Admin.controllers :auth_codes do
  get :index do
    @title = "Auth_codes"
    @auth_codes = AuthCode.all
    render 'auth_codes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'auth_code')
    @auth_code = AuthCode.new
    render 'auth_codes/new'
  end

  post :create do
    @auth_code = AuthCode.new(params[:auth_code])
    if @auth_code.save
      @title = pat(:create_title, :model => "auth_code #{@auth_code.id}")
      flash[:success] = pat(:create_success, :model => 'AuthCode')
      params[:save_and_continue] ? redirect(url(:auth_codes, :index)) : redirect(url(:auth_codes, :edit, :id => @auth_code.id))
    else
      @title = pat(:create_title, :model => 'auth_code')
      flash.now[:error] = pat(:create_error, :model => 'auth_code')
      render 'auth_codes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "auth_code #{params[:id]}")
    @auth_code = AuthCode.find(params[:id])
    if @auth_code
      render 'auth_codes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'auth_code', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "auth_code #{params[:id]}")
    @auth_code = AuthCode.find(params[:id])
    if @auth_code
      if @auth_code.update_attributes(params[:auth_code])
        flash[:success] = pat(:update_success, :model => 'Auth_code', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:auth_codes, :index)) :
          redirect(url(:auth_codes, :edit, :id => @auth_code.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'auth_code')
        render 'auth_codes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'auth_code', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Auth_codes"
    auth_code = AuthCode.find(params[:id])
    if auth_code
      if auth_code.destroy
        flash[:success] = pat(:delete_success, :model => 'Auth_code', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'auth_code')
      end
      redirect url(:auth_codes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'auth_code', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Auth_codes"
    unless params[:auth_code_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'auth_code')
      redirect(url(:auth_codes, :index))
    end
    ids = params[:auth_code_ids].split(',').map(&:strip)
    auth_codes = AuthCode.find(ids)
    
    if auth_codes.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Auth_codes', :ids => "#{ids.to_sentence}")
    end
    redirect url(:auth_codes, :index)
  end
end
