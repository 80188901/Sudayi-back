  require 'carrierwave/mongoid'
Fancyshpv2::Admin.controllers :image_items do
  get :index do
    @title = "Image_items"
    @image_items = ImageItem.all
    render 'image_items/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'image_item')
    @image_item = ImageItem.new
    render 'image_items/new'
  end

  post :create do
    @image_item = ImageItem.new(params[:image_item])
    if @image_item.save
      @title = pat(:create_title, :model => "image_item #{@image_item.id}")
      flash[:success] = pat(:create_success, :model => 'ImageItem')
      params[:save_and_continue] ? redirect(url(:image_items, :index)) : redirect(url(:image_items, :edit, :id => @image_item.id))
    else
      @title = pat(:create_title, :model => 'image_item')
      flash.now[:error] = pat(:create_error, :model => 'image_item')
      render 'image_items/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "image_item #{params[:id]}")
    @image_item = ImageItem.find(params[:id])
    if @image_item
      render 'image_items/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'image_item', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "image_item #{params[:id]}")
    @image_item = ImageItem.find(params[:id])
    if @image_item
      if @image_item.update_attributes(params[:image_item])
        flash[:success] = pat(:update_success, :model => 'Image_item', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:image_items, :index)) :
          redirect(url(:image_items, :edit, :id => @image_item.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'image_item')
        render 'image_items/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'image_item', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Image_items"
    image_item = ImageItem.find(params[:id])
    if image_item
      if image_item.destroy
        flash[:success] = pat(:delete_success, :model => 'Image_item', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'image_item')
      end
      redirect url(:image_items, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'image_item', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Image_items"
    unless params[:image_item_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'image_item')
      redirect(url(:image_items, :index))
    end
    ids = params[:image_item_ids].split(',').map(&:strip)
    image_items = ImageItem.find(ids)
    
    if image_items.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Image_items', :ids => "#{ids.to_sentence}")
    end
    redirect url(:image_items, :index)
  end
end
