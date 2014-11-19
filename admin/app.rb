module Fancyshpv2
  class Admin < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Admin::AccessControl

    ##
    # Application configuration options
    #
    # set :raise_errors, true         # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true          # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true      # Shows a stack trace in browser (default for development)
    # set :logging, true              # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, "foo/bar"   # Location for static assets (default root/public)
    # set :reload, false              # Reload application files (default in development)
    # set :default_builder, "foo"     # Set a custom form builder (default 'StandardFormBuilder')
   #set :locale_path, "zh_CN"         # Set path for I18n translations (default your_app/locales)
    # disable :sessions               # Disabled sessions by default (enable if needed)
    # disable :flash                  # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout              # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    set :admin_model, 'Account'
    set :login_page,  '/sessions/new'
     I18n.default_locale = :zh_cn

    enable  :sessions
    disable :store_location
   CarrierWave.root = File.join(Padrino.root, "public")
    access_control.roles_for :any do |role|
      role.protect '/'
      role.allow   '/sessions'
    end

    access_control.roles_for :admin do |role|
      role.project_module :lang_dicts, '/lang_dicts'
      role.project_module :lang_cates, '/lang_cates'
      role.project_module :statics, '/statics'
      role.project_module :categories, '/categories'
      role.project_module :desired_prodcuts, '/desired_prodcuts'
      role.project_module :wishes, '/wishes'
      role.project_module :website_collections, '/website_collections'
      role.project_module :product_collections, '/product_collections'
      role.project_module :account_collections, '/account_collections'
      role.project_module :post_collections, '/post_collections'
      role.project_module :templetes, '/templetes'
      role.project_module :stores, '/stores'
      role.project_module :massages, '/massages'
      role.project_module :states, '/states'
      role.project_module :thumbups, '/thumbups'
      role.project_module :coments, '/coments'
      role.project_module :posts, '/posts'
      role.project_module :city_distances, '/city_distances'
      role.project_module :area_distances, '/area_distances'
      role.project_module :image_items, '/image_items'
      role.project_module :payments, '/payments'
      role.project_module :orders, '/orders'
      role.project_module :friends, '/friends'
      role.project_module :addresses, '/addresses'
      role.project_module :details, '/details'
      role.project_module :streets, '/streets'
      role.project_module :areas, '/areas'
      role.project_module :cities, '/cities'
      role.project_module :provinces, '/provinces'
      role.project_module :countries, '/countries'
      role.project_module :planets, '/planets'
      role.project_module :products, '/products'
      role.project_module :websites, '/websites'
      role.project_module :accounts, '/accounts'
    end

    # Custom error management 
    error(403) { @title = "Error 403"; render('errors/403', :layout => :error) }
    error(404) { @title = "Error 404"; render('errors/404', :layout => :error) }
    error(500) { @title = "Error 500"; render('errors/500', :layout => :error) }
  end
end
