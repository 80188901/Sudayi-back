Fancyshpv2::Admin.controllers :base do
  get :index, :map => "/" do
    I18n.default_locale = :zh_cn
    render "base/index"
  end
end
