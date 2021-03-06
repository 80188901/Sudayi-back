Fancyshpv2::App.controllers :wechats do
 require 'net/http'
  require "rexml/document"
   disable :protect_from_csrf
   before do
	@wechat_info=WechatInfo.first
   end
get :home do
	@url="https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid=#{@wechat_info.appid}&pre_auth_code=#{@wechat_info.pre_auth_code}&redirect_uri=http://shop.29mins.com/wechats/auth_code"
	render :home,:layout=>false
end 

post :receive do
	logger.info params
	str=request.body.read
	logger.info str
	doc=REXML::Document.new str
	root=doc.root
	ticket=root.get_elements('Encrypt')[0][0]	
	
	if Wechat.check_info(params[:timestamp],params[:nonce],ticket,params[:msg_signature])
		result=Wechat.new.decrypt(ticket.to_s)
		logger.info result.to_json
		xml=REXML::Document.new result
		xml_root=xml.root
		if xml_root.get_elements('InfoType')[0][0].to_s=='component_verify_ticket'
		   verify_ticket=xml_root.get_elements('ComponentVerifyTicket')[0][0]
		   @wechat_info.ticket=verify_ticket.to_s
		   url='https://api.weixin.qq.com/cgi-bin/component/api_component_token'
		   body='{"component_appid":"'+@wechat_info.appid+'","component_appsecret":"'+@wechat_info.appsecret+'","component_verify_ticket":"'+@wechat_info.ticket+'"}'
		   @wechat_info.access_token=JSON.parse(Wechat.sent_to_wechat(url,body))['component_access_token']
		   url='https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token='+@wechat_info.access_token
		   body='{"component_appid":"'+@wechat_info.appid+'"}'
		   @wechat_info.pre_auth_code=JSON.parse(Wechat.sent_to_wechat(url,body))['pre_auth_code']
		   @wechat_info.save
		else
		   appid=xml_root.get_elements('AuthorizerAppid')[0][0].to_s
		   AuthCode.where(appid:appid).first.delete
		end
	else
		logger.info 'error'
	end
	render :html,'success'
end


get :auth_code do
	logger.info params
	
	url='https://api.weixin.qq.com/cgi-bin/component/api_query_auth?component_access_token='+@wechat_info.access_token
	body='{"component_appid":"'+@wechat_info.appid+'"," authorization_code": "'+params[:auth_code]+'"}'
	logger.info body
	result=Wechat.sent_to_wechat(url,body)
	auth_code=AuthCode.create(code:params[:auth_code])
	logger.info result.to_json
	redirect(url(:wechats,:gzh_parameter,:auth_code_id=>auth_code._id))
end

get :gzh_parameter do
	auth_code=AuthCode.find(params[:auth_code_id])
	url='https://api.weixin.qq.com/cgi-bin/component/api_query_auth?component_access_token='+@wechat_info.access_token
        body='{"component_appid":"'+@wechat_info.appid+'","authorization_code":"'+auth_code.code+'"}'
        result=Wechat.sent_to_wechat(url,body)
	logger.info result.to_json
	json=JSON.parse(result)
	auth_code.token=json['authorization_info']['authorizer_access_token']
	auth_code.appid=json['authorization_info']['authorizer_appid']
	auth_code.refresh_token=json['authorization_info']['authorizer_refresh_token']
	arr=[]
	json['authorization_info']['func_info'].each do |a|
		arr<<a['funcscope_category']['id']
	end
	auth_code.func_info=arr
	auth_code.save
	redirect(url(:wechats,:gzh_info,auth_code_id:auth_code._id))
end

get :gzh_info do
	auth_code=AuthCode.find(params[:auth_code_id])
	if auth_code.gzh_info
	   gzh_info=auth_code.gzh_info
	else
	   gzh_info=GzhInfo.new
	   gzh_info.auth_code=auth_code
	end
	url='https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_info?component_access_token='+@wechat_info.access_token
	body='{"component_appid":"'+@wechat_info.appid+'","authorizer_appid":"'+auth_code.appid+'"}'
	result=JSON.parse(Wechat.sent_to_wechat(url,body))['authorizer_info']
	gzh_info.nick_name=result['nick_name']
	gzh_info.head_image=result['head_img']
	gzh_info.service_type=result['service_type_info']['id']
	gzh_info.verify_type=result['verify_type_info']['id']
	gzh_info.user_name=result['user_name']
	gzh_info.alias=result['alias']
	gzh_info.qrcode_url=result['qrcode_url']
	gzh_info.save
	redirect(url(:wechats,:option_info,auth_code_id:auth_code._id))
end

get :option_info do
	auth_code=AuthCode.find(params[:auth_code_id])
	option=['location_report','voice_recognize','customer_service']
	url='https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_option?component_access_token='+@wechat_info.access_token
	logger.info url
	option.each do |a|
	  body='{"component_appid":"'+@wechat_info.appid+'","authorizer_appid":"'+auth_code.appid+'","option_name":"'+a+'"}'
	  result=JSON.parse(Wechat.sent_to_wechat(url,body))['option_value']
	  auth_code.gzh_info.send(a+'=',result)
	end
	auth_code.gzh_info.save
end

post :process_request,:map=>'/message',:with=>:appid do
	str=request.body.read
        doc=REXML::Document.new str
        root=doc.root
        message=root.get_elements('Encrypt')[0][0]
	if Wechat.check_info(params[:timestamp],params[:nonce],message,params[:msg_signature])
             result=Wechat.new.decrypt(message.to_s)
             logger.info result.to_json
	     xml=REXML::Document.new result
             xml_root=xml.root
	     case xml_root.get_elements('MsgType')[0][0]
	        when 'event' then
		   
 	        when 'text'  then
	        else
	     end
	end
end
end
