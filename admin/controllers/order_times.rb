Fancyshpv2::Admin.controllers :order_times do
  get :index do
    @title = "Order_times"
    @order_times = OrderTime.all
    render 'order_times/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'order_time')
    @order_time = OrderTime.new
    render 'order_times/new'
  end

  post :create do
    @order_time = OrderTime.new(params[:order_time])
    if @order_time.save
      @title = pat(:create_title, :model => "order_time #{@order_time.id}")
      flash[:success] = pat(:create_success, :model => 'OrderTime')
      params[:save_and_continue] ? redirect(url(:order_times, :index)) : redirect(url(:order_times, :edit, :id => @order_time.id))
    else
      @title = pat(:create_title, :model => 'order_time')
      flash.now[:error] = pat(:create_error, :model => 'order_time')
      render 'order_times/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "order_time #{params[:id]}")
    @order_time = OrderTime.find(params[:id])
    if @order_time
      render 'order_times/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'order_time', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "order_time #{params[:id]}")
    @order_time = OrderTime.find(params[:id])
    if @order_time
      if @order_time.update_attributes(params[:order_time])
        flash[:success] = pat(:update_success, :model => 'Order_time', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:order_times, :index)) :
          redirect(url(:order_times, :edit, :id => @order_time.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'order_time')
        render 'order_times/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'order_time', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Order_times"
    order_time = OrderTime.find(params[:id])
    if order_time
      if order_time.destroy
        flash[:success] = pat(:delete_success, :model => 'Order_time', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'order_time')
      end
      redirect url(:order_times, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'order_time', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Order_times"
    unless params[:order_time_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'order_time')
      redirect(url(:order_times, :index))
    end
    ids = params[:order_time_ids].split(',').map(&:strip)
    order_times = OrderTime.find(ids)
    
    if order_times.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Order_times', :ids => "#{ids.to_sentence}")
    end
    redirect url(:order_times, :index)
  end
end
