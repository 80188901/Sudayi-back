Fancyshpv2::Admin.controllers :payments do
  get :index do
    @title = "Payments"
    @payments = Payment.all
    render 'payments/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'payment')
    @payment = Payment.new
    render 'payments/new'
  end

  post :create do
    @payment = Payment.new(params[:payment])
    if @payment.save
      @title = pat(:create_title, :model => "payment #{@payment.id}")
      flash[:success] = pat(:create_success, :model => 'Payment')
      params[:save_and_continue] ? redirect(url(:payments, :index)) : redirect(url(:payments, :edit, :id => @payment.id))
    else
      @title = pat(:create_title, :model => 'payment')
      flash.now[:error] = pat(:create_error, :model => 'payment')
      render 'payments/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "payment #{params[:id]}")
    @payment = Payment.find(params[:id])
    if @payment
      render 'payments/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'payment', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "payment #{params[:id]}")
    @payment = Payment.find(params[:id])
    if @payment
      if @payment.update_attributes(params[:payment])
        flash[:success] = pat(:update_success, :model => 'Payment', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:payments, :index)) :
          redirect(url(:payments, :edit, :id => @payment.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'payment')
        render 'payments/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'payment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Payments"
    payment = Payment.find(params[:id])
    if payment
      if payment.destroy
        flash[:success] = pat(:delete_success, :model => 'Payment', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'payment')
      end
      redirect url(:payments, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'payment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Payments"
    unless params[:payment_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'payment')
      redirect(url(:payments, :index))
    end
    ids = params[:payment_ids].split(',').map(&:strip)
    payments = Payment.find(ids)
    
    if payments.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Payments', :ids => "#{ids.to_sentence}")
    end
    redirect url(:payments, :index)
  end
end
