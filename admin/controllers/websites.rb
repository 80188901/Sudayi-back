Fancyshpv2::Admin.controllers :websites do
  get :index do
    @title = "Websites"
    @websites = Website.all
    render 'websites/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'website')
    @website = Website.new
    render 'websites/new'
  end

  post :create do
    @website = Website.new(params[:website])
    if @website.save
      @title = pat(:create_title, :model => "website #{@website.id}")
      flash[:success] = pat(:create_success, :model => 'Website')
      params[:save_and_continue] ? redirect(url(:websites, :index)) : redirect(url(:websites, :edit, :id => @website.id))
    else
      @title = pat(:create_title, :model => 'website')
      flash.now[:error] = pat(:create_error, :model => 'website')
      render 'websites/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "website #{params[:id]}")
    @website = Website.find(params[:id])
    if @website
      render 'websites/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'website', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "website #{params[:id]}")
    @website = Website.find(params[:id])
    if @website
      if @website.update_attributes(params[:website])
        flash[:success] = pat(:update_success, :model => 'Website', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:websites, :index)) :
          redirect(url(:websites, :edit, :id => @website.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'website')
        render 'websites/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'website', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Websites"
    website = Website.find(params[:id])
    if website
      if website.destroy
        flash[:success] = pat(:delete_success, :model => 'Website', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'website')
      end
      redirect url(:websites, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'website', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Websites"
    unless params[:website_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'website')
      redirect(url(:websites, :index))
    end
    ids = params[:website_ids].split(',').map(&:strip)
    websites = Website.find(ids)
    
    if websites.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Websites', :ids => "#{ids.to_sentence}")
    end
    redirect url(:websites, :index)
  end
end
