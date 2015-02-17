Fancyshpv2::Admin.controllers :node_ways do
  get :index do
    @title = "Node_ways"
    @node_ways = NodeWay.all
    render 'node_ways/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'node_way')
    @node_way = NodeWay.new
    render 'node_ways/new'
  end

  post :create do
    @node_way = NodeWay.new(params[:node_way])
    if @node_way.save
      @title = pat(:create_title, :model => "node_way #{@node_way.id}")
      flash[:success] = pat(:create_success, :model => 'NodeWay')
      params[:save_and_continue] ? redirect(url(:node_ways, :index)) : redirect(url(:node_ways, :edit, :id => @node_way.id))
    else
      @title = pat(:create_title, :model => 'node_way')
      flash.now[:error] = pat(:create_error, :model => 'node_way')
      render 'node_ways/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "node_way #{params[:id]}")
    @node_way = NodeWay.find(params[:id])
    if @node_way
      render 'node_ways/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'node_way', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "node_way #{params[:id]}")
    @node_way = NodeWay.find(params[:id])
    if @node_way
      if @node_way.update_attributes(params[:node_way])
        flash[:success] = pat(:update_success, :model => 'Node_way', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:node_ways, :index)) :
          redirect(url(:node_ways, :edit, :id => @node_way.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'node_way')
        render 'node_ways/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'node_way', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Node_ways"
    node_way = NodeWay.find(params[:id])
    if node_way
      if node_way.destroy
        flash[:success] = pat(:delete_success, :model => 'Node_way', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'node_way')
      end
      redirect url(:node_ways, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'node_way', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Node_ways"
    unless params[:node_way_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'node_way')
      redirect(url(:node_ways, :index))
    end
    ids = params[:node_way_ids].split(',').map(&:strip)
    node_ways = NodeWay.find(ids)
    
    if node_ways.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Node_ways', :ids => "#{ids.to_sentence}")
    end
    redirect url(:node_ways, :index)
  end
end
