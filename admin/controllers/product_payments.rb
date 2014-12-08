Fancyshpv2::Admin.controllers :product_payments do
  get :index do
    @title = "Product_payments"
    @product_payments = ProductPayment.all
    render 'product_payments/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'product_payment')
    @product_payment = ProductPayment.new
    render 'product_payments/new'
  end

  post :create do
    @product_payment = ProductPayment.new(params[:product_payment])
    if @product_payment.save
      @title = pat(:create_title, :model => "product_payment #{@product_payment.id}")
      flash[:success] = pat(:create_success, :model => 'ProductPayment')
      params[:save_and_continue] ? redirect(url(:product_payments, :index)) : redirect(url(:product_payments, :edit, :id => @product_payment.id))
    else
      @title = pat(:create_title, :model => 'product_payment')
      flash.now[:error] = pat(:create_error, :model => 'product_payment')
      render 'product_payments/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "product_payment #{params[:id]}")
    @product_payment = ProductPayment.find(params[:id])
    if @product_payment
      render 'product_payments/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'product_payment', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "product_payment #{params[:id]}")
    @product_payment = ProductPayment.find(params[:id])
    if @product_payment
      if @product_payment.update_attributes(params[:product_payment])
        flash[:success] = pat(:update_success, :model => 'Product_payment', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:product_payments, :index)) :
          redirect(url(:product_payments, :edit, :id => @product_payment.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'product_payment')
        render 'product_payments/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'product_payment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Product_payments"
    product_payment = ProductPayment.find(params[:id])
    if product_payment
      if product_payment.destroy
        flash[:success] = pat(:delete_success, :model => 'Product_payment', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'product_payment')
      end
      redirect url(:product_payments, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'product_payment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Product_payments"
    unless params[:product_payment_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'product_payment')
      redirect(url(:product_payments, :index))
    end
    ids = params[:product_payment_ids].split(',').map(&:strip)
    product_payments = ProductPayment.find(ids)
    
    if product_payments.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Product_payments', :ids => "#{ids.to_sentence}")
    end
    redirect url(:product_payments, :index)
  end
end
