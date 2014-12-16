Fancyshpv2::Admin.controllers :coupons do
  get :index do
    @title = "Coupons"
    @coupons = Coupon.all
    render 'coupons/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'coupon')
    @coupon = Coupon.new
    render 'coupons/new'
  end

  post :create do
    @coupon = Coupon.new(params[:coupon])
    if @coupon.save
      @title = pat(:create_title, :model => "coupon #{@coupon.id}")
      flash[:success] = pat(:create_success, :model => 'Coupon')
      params[:save_and_continue] ? redirect(url(:coupons, :index)) : redirect(url(:coupons, :edit, :id => @coupon.id))
    else
      @title = pat(:create_title, :model => 'coupon')
      flash.now[:error] = pat(:create_error, :model => 'coupon')
      render 'coupons/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "coupon #{params[:id]}")
    @coupon = Coupon.find(params[:id])
    if @coupon
      render 'coupons/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'coupon', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "coupon #{params[:id]}")
    @coupon = Coupon.find(params[:id])
    if @coupon
      if @coupon.update_attributes(params[:coupon])
        flash[:success] = pat(:update_success, :model => 'Coupon', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:coupons, :index)) :
          redirect(url(:coupons, :edit, :id => @coupon.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'coupon')
        render 'coupons/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'coupon', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Coupons"
    coupon = Coupon.find(params[:id])
    if coupon
      if coupon.destroy
        flash[:success] = pat(:delete_success, :model => 'Coupon', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'coupon')
      end
      redirect url(:coupons, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'coupon', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Coupons"
    unless params[:coupon_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'coupon')
      redirect(url(:coupons, :index))
    end
    ids = params[:coupon_ids].split(',').map(&:strip)
    coupons = Coupon.find(ids)
    
    if coupons.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Coupons', :ids => "#{ids.to_sentence}")
    end
    redirect url(:coupons, :index)
  end
end
