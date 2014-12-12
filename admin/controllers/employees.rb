Fancyshpv2::Admin.controllers :employees do
  get :index do
    @title = "Employees"
    @employees = Employee.all
    render 'employees/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'employee')
    @employee = Employee.new
    render 'employees/new'
  end

  post :create do
    @employee = Employee.new(params[:employee])
    if @employee.save
      @title = pat(:create_title, :model => "employee #{@employee.id}")
      flash[:success] = pat(:create_success, :model => 'Employee')
      params[:save_and_continue] ? redirect(url(:employees, :index)) : redirect(url(:employees, :edit, :id => @employee.id))
    else
      @title = pat(:create_title, :model => 'employee')
      flash.now[:error] = pat(:create_error, :model => 'employee')
      render 'employees/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "employee #{params[:id]}")
    @employee = Employee.find(params[:id])
    if @employee
      render 'employees/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "employee #{params[:id]}")
    @employee = Employee.find(params[:id])
    if @employee
      if @employee.update_attributes(params[:employee])
        flash[:success] = pat(:update_success, :model => 'Employee', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:employees, :index)) :
          redirect(url(:employees, :edit, :id => @employee.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'employee')
        render 'employees/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Employees"
    employee = Employee.find(params[:id])
    if employee
      if employee.destroy
        flash[:success] = pat(:delete_success, :model => 'Employee', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'employee')
      end
      redirect url(:employees, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Employees"
    unless params[:employee_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'employee')
      redirect(url(:employees, :index))
    end
    ids = params[:employee_ids].split(',').map(&:strip)
    employees = Employee.find(ids)
    
    if employees.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Employees', :ids => "#{ids.to_sentence}")
    end
    redirect url(:employees, :index)
  end
end
