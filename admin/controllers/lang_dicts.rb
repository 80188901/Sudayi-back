Fancyshpv2::Admin.controllers :lang_dicts do
  get :index do
    @title = "Lang_dicts"
    @lang_dicts = LangDict.all
    render 'lang_dicts/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'lang_dict')
    @lang_dict = LangDict.new
    render 'lang_dicts/new'
  end

  post :create do
    @lang_dict = LangDict.new(params[:lang_dict])
    if @lang_dict.save
      @title = pat(:create_title, :model => "lang_dict #{@lang_dict.id}")
      flash[:success] = pat(:create_success, :model => '字典词条')
      params[:save_and_continue] ? redirect(url(:lang_dicts, :index)) : redirect(url(:lang_dicts, :edit, :id => @lang_dict.id))
    else
      @title = pat(:create_title, :model => 'lang_dict')
      flash.now[:error] = pat(:create_error, :model => 'lang_dict')
      render 'lang_dicts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "lang_dict #{params[:id]}")
    @lang_dict = LangDict.find(params[:id])
    if @lang_dict
      render 'lang_dicts/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'lang_dict', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "lang_dict #{params[:id]}")
    @lang_dict = LangDict.find(params[:id])
    if @lang_dict
      if @lang_dict.update_attributes(params[:lang_dict])
        flash[:success] = pat(:update_success, :model => 'Lang_dict', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:lang_dicts, :index)) :
          redirect(url(:lang_dicts, :edit, :id => @lang_dict.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'lang_dict')
        render 'lang_dicts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'lang_dict', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Lang_dicts"
    lang_dict = LangDict.find(params[:id])
    if lang_dict
      if lang_dict.destroy
        flash[:success] = pat(:delete_success, :model => 'Lang_dict', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'lang_dict')
      end
      redirect url(:lang_dicts, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'lang_dict', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Lang_dicts"
    unless params[:lang_dict_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'lang_dict')
      redirect(url(:lang_dicts, :index))
    end
    ids = params[:lang_dict_ids].split(',').map(&:strip)
    lang_dicts = LangDict.find(ids)
    
    if lang_dicts.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Lang_dicts', :ids => "#{ids.to_sentence}")
    end
    redirect url(:lang_dicts, :index)
  end
end
