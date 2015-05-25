Fancyshpv2::App.controllers :gzhs do
	require 'net/http'
  require "rexml/document"
	disable :protect_from_csrf
   get :home,:map=>'/gzhs' do
   if  Gzh.check_weixin_legality(params[:timestamp], params[:nonce],params[:signature])
 
   	return render :html,params[:echostr]
  
  else
     #check failure
  end
  end  
post :process_request ,:map=>'/gzhs' do
if  Gzh.check_weixin_legality(params[:timestamp], params[:nonce],params[:signature])
     str=request.body.read.strip	
	logger.info str
     doc = REXML::Document.new str
     @root=doc.root
     xml=@root.get_elements("MsgType")[0][0]
  if xml=='event'
    if @root.get_elements('Event')[0][0]=='subscribe'
       render "/gzhs/process_request",:layout=>false
     elsif @root.get_elements('Event')[0][0]=='unsubscribe'
       render "/gzhs/process_request",:layout=>false
     end
   elsif xml=='text'
	#@href="https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx3a8121669c822f7f&redirect_uri=http://shop.29mins.com/gzhs/get_code&response_type=code&scope=snsapi_base&state=123#wechat_redirect"
	@href='hello'
    render "/gzhs/response_msg",:layout=>false
  end
 end
end  

get :get_code do
	code=params[:code]
	uri=URI("https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx3a8121669c822f7f&secret=c39af384f46722e3dfa527c255529011&code=#{code}&grant_type=authorization_code")
	token=''
	open_id=''
	refresh_token=''
	Net::HTTP.start(uri.host,uri.port,:use_ssl=>uri.scheme=='https') do |http|
		request = Net::HTTP::Get.new uri
		response = http.request request
		arr=JSON.parse response.body
		token=arr["access_token"]
		refresh_token=arr["refresh_token"]
		open_id=arr["openid"]
	end
	redirect(url(:gzhs,:get_userinfo,:token=>token,:open_id=>open_id))
end

get :get_userinfo do
	uri=URI("https://api.weixin.qq.com/sns/userinfo?access_token=#{params[:token]}&openid=#{params[:open_id]}")
	Net::HTTP.start(uri.host,uri.port,:use_ssl=>uri.scheme=='https') do |http|
		request = Net::HTTP::Get.new uri
		response = http.request request
		logger.info response.body
	end
end
get :setmenu   do
  tok=Gzh.get_access_token
  puts tok
 uri = URI("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{tok}"  )

Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Post.new(uri,{'Content-Type' => 'application/json'})
 #request.set_form_data(Wechat.menu_to_json)
 request.body=Gzh.menu_to_json
    response = http.request(request) 
    
    puts response.body
end
redirect(url(:bestcourier,:main))
end
end
