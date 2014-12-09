module Fancyshpv2
  class App < Padrino::Application
    #register Padrino::Contrib::AutoLocale
  #set :locales, [:en, :ru, :de] # First locale is the default locale
    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions
 get '/' do
    render('index/index', :layout => :index) 
    #'网站正在维护中'
  end

  get :category do
    render('index/category', :layout => :index) 
  end

  get :error do
    render('index/404_error', :layout => :index) 
  end

  get :blog do
  render('index/blog', :layout => :index) 
  end

  get :about do
     @image_item = ImageItem.where(:account_id => 'simon').first
     render('index/about_us', :layout => :index) 
  end

  get :index_2 do
    render('index/index-2', :layout => :index) 
  end 

  get :view do 
   render('index/view', :layout => :index) 
  end

  get :cart do
    render('index/cart', :layout => :index) 
  end

  get :faq do
     render('index/faq', :layout => :index) 
  end

  get :account_create do
    render('index/account_create', :layout => :index) 
 end

 post :new_account do
    @account = Account.new(params[:account])
    if @account.save
      params[:save_and_continue] ? redirect(url('/')) : redirect(url( '/', :id => @account.id))
    else
      render( 'index/index', :layout => :index)
    end
 end

  get :account_login do
   render('index/account_login', :layout => :index) 
  end

  post :login  do
    if account = Account.login(params[:email], params[:password])
      session[:account]=account
       redirect url('/')
    elsif Padrino.env == :development && params[:bypass]
      account = Account.first
      session[:account]=account
       redirect url('/')
    else
      params[:email] = h(params[:email])
      @flash = '帐号或密码错误'
      render("index/account_login", :layout => :index)
    end
  end

  get :login_out do
     session[:account] = nil
     redirect url('/')
  end

  get :contact_us do
   render('index/contact_us', :layout => :index) 
  end

  get :erweima do
   qr=RQRCode::QRCode.new('http://'+request.host)
png=qr.to_img  # returns an instance of ChunkyPNG
png.resize(300, 300).save('/home/simon/fancyshop_0.3/public/images/foo.png')
render('index/foo', :layout => :index) 
  end
    ##
    # Caching support.
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache.new(:LRUHash) # Keeps cached values in memory
    # set :cache, Padrino::Cache.new(:Memcached) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Memcached, '127.0.0.1:11211', :exception_retry_limit => 1)
    # set :cache, Padrino::Cache.new(:Memcached, :backend => memcached_or_dalli_instance)
    # set :cache, Padrino::Cache.new(:Redis) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Redis, :host => '127.0.0.1', :port => 6379, :db => 0)
    # set :cache, Padrino::Cache.new(:Redis, :backend => redis_instance)
    # set :cache, Padrino::Cache.new(:Mongo) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Mongo, :backend => mongo_client_instance)
    # set :cache, Padrino::Cache.new(:File, :dir => Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options.
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    #set :locale_path, 'zh_CN'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    error 404 do
         render 'index/404_error'
     end
    #
       error 500 do
         render 'errors/500_error'
       end
    #
  end
end
