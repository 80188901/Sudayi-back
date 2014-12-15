Fancyshpv2::Admin.controllers :store_employees do
  get :index do
    @title = "Store_employees"
    @store_employees = StoreEmployee.all
    render 'store_employees/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'store_employee')
    @store_employee = StoreEmployee.new
    render 'store_employees/new'
  end

  post :create do
    @store_employee = StoreEmployee.new(params[:store_employee])
    if @store_employee.save
      @title = pat(:create_title, :model => "store_employee #{@store_employee.id}")
      flash[:success] = pat(:create_success, :model => 'StoreEmployee')
      params[:save_and_continue] ? redirect(url(:store_employees, :index)) : redirect(url(:store_employees, :edit, :id => @store_employee.id))
    else
      @title = pat(:create_title, :model => 'store_employee')
      flash.now[:error] = pat(:create_error, :model => 'store_employee')
      render 'store_employees/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "store_employee #{params[:id]}")
    @store_employee = StoreEmployee.find(params[:id])
    if @store_employee
      render 'store_employees/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'store_employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "store_employee #{params[:id]}")
    @store_employee = StoreEmployee.find(params[:id])
    if @store_employee
      if @store_employee.update_attributes(params[:store_employee])
        flash[:success] = pat(:update_success, :model => 'Store_employee', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:store_employees, :index)) :
          redirect(url(:store_employees, :edit, :id => @store_employee.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'store_employee')
        render 'store_employees/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'store_employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Store_employees"
    store_employee = StoreEmployee.find(params[:id])
    if store_employee
      if store_employee.destroy
        flash[:success] = pat(:delete_success, :model => 'Store_employee', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'store_employee')
      end
      redirect url(:store_employees, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'store_employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Store_employees"
    unless params[:store_employee_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'store_employee')
      redirect(url(:store_employees, :index))
    end
    ids = params[:store_employee_ids].split(',').map(&:strip)
    store_employees = StoreEmployee.find(ids)
    
    if store_employees.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Store_employees', :ids => "#{ids.to_sentence}")
    end
    redirect url(:store_employees, :index)
  end
end
