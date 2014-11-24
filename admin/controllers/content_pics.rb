Fancyshpv2::Admin.controllers :content_pics do
  get :index do
    @title = "Content_pics"
    @content_pics = ContentPic.all
    render 'content_pics/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'content_pic')
    @content_pic = ContentPic.new
    render 'content_pics/new'
  end

  post :create do
    @content_pic = ContentPic.new(params[:content_pic])
    if @content_pic.save
      @title = pat(:create_title, :model => "content_pic #{@content_pic.id}")
      flash[:success] = pat(:create_success, :model => 'ContentPic')
      params[:save_and_continue] ? redirect(url(:content_pics, :index)) : redirect(url(:content_pics, :edit, :id => @content_pic.id))
    else
      @title = pat(:create_title, :model => 'content_pic')
      flash.now[:error] = pat(:create_error, :model => 'content_pic')
      render 'content_pics/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "content_pic #{params[:id]}")
    @content_pic = ContentPic.find(params[:id])
    if @content_pic
      render 'content_pics/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'content_pic', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "content_pic #{params[:id]}")
    @content_pic = ContentPic.find(params[:id])
    if @content_pic
      if @content_pic.update_attributes(params[:content_pic])
        flash[:success] = pat(:update_success, :model => 'Content_pic', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:content_pics, :index)) :
          redirect(url(:content_pics, :edit, :id => @content_pic.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'content_pic')
        render 'content_pics/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'content_pic', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Content_pics"
    content_pic = ContentPic.find(params[:id])
    if content_pic
      if content_pic.destroy
        flash[:success] = pat(:delete_success, :model => 'Content_pic', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'content_pic')
      end
      redirect url(:content_pics, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'content_pic', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Content_pics"
    unless params[:content_pic_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'content_pic')
      redirect(url(:content_pics, :index))
    end
    ids = params[:content_pic_ids].split(',').map(&:strip)
    content_pics = ContentPic.find(ids)
    
    if content_pics.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Content_pics', :ids => "#{ids.to_sentence}")
    end
    redirect url(:content_pics, :index)
  end
end
