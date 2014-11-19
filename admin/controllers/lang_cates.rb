Fancyshpv2::Admin.controllers :lang_cates do
  get :index do
    @title = "Lang_cates"
    @lang_cates = LangCate.all
    render 'lang_cates/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'lang_cate')
    @lang_cate = LangCate.new
    render 'lang_cates/new'
  end

  post :create do
    @lang_cate = LangCate.new(params[:lang_cate])
    if @lang_cate.save
      @title = pat(:create_title, :model => "lang_cate #{@lang_cate.id}")
      flash[:success] = pat(:create_success, :model => 'LangCate')
      params[:save_and_continue] ? redirect(url(:lang_cates, :index)) : redirect(url(:lang_cates, :edit, :id => @lang_cate.id))
    else
      @title = pat(:create_title, :model => 'lang_cate')
      flash.now[:error] = pat(:create_error, :model => 'lang_cate')
      render 'lang_cates/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "lang_cate #{params[:id]}")
    @lang_cate = LangCate.find(params[:id])
    if @lang_cate
      render 'lang_cates/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'lang_cate', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "lang_cate #{params[:id]}")
    @lang_cate = LangCate.find(params[:id])
    if @lang_cate
      if @lang_cate.update_attributes(params[:lang_cate])
        flash[:success] = pat(:update_success, :model => 'Lang_cate', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:lang_cates, :index)) :
          redirect(url(:lang_cates, :edit, :id => @lang_cate.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'lang_cate')
        render 'lang_cates/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'lang_cate', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Lang_cates"
    lang_cate = LangCate.find(params[:id])
    if lang_cate
      if lang_cate.destroy
        flash[:success] = pat(:delete_success, :model => 'Lang_cate', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'lang_cate')
      end
      redirect url(:lang_cates, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'lang_cate', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Lang_cates"
    unless params[:lang_cate_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'lang_cate')
      redirect(url(:lang_cates, :index))
    end
    ids = params[:lang_cate_ids].split(',').map(&:strip)
    lang_cates = LangCate.find(ids)
    
    if lang_cates.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Lang_cates', :ids => "#{ids.to_sentence}")
    end
    redirect url(:lang_cates, :index)
  end
end
