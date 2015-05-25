
class Wechat
	require 'digest/sha1'
	require 'base64' 
	require 'net/http'
	#@token='tiandiwang'
	#@@appid='wx31aa7bfa0ae30872'
	#@@appsecret='0c79e1fa963cd80cc0be99b20a18faeb'
	#@@encryptkey='IuvWqPHol3TrXsLYMuOKisVFjewCwIUJBJ6ucMBKjp8'
	@@wechat_info=WechatInfo.first	
	def self.check_info(timestamp,nonce,msg_encrypt,signature)
		str=[@@wechat_info.token,timestamp,nonce,msg_encrypt].sort.join
		sha1=Digest::SHA1.hexdigest(str.to_s)
		if signature == sha1
   		   return true
  		else
     	           return false
 	        end	
	end
		
#	def  self.get_access_token(ticket)
# 	  uri = URI('https://api.weixin.qq.com/cgi-bin/component/api_component_token')
#		Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
# 		   request= Net::HTTP::Post.new(uri,{'Content-Type'=>'application/json'})
#		   request.body='{"component_appid":"'+@@wechat_info.appid+'","component_appsecret":"'+@@wechat_info.appsecret+'","component_verify_ticket":"'+ticket+'"}'
#			puts request.body
# 		    response=http.request request
#		    response.body
#	        end
#	end
	
	def self.sent_to_wechat(url,body)
		 uri = URI(url)
                Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
                   request= Net::HTTP::Post.new(uri,{'Content-Type'=>'application/json'})
                   request.body=body
                        puts request.body
                    response=http.request request
                    response.body
                end
	end
	
	def self.refresh_gzh_token(component_token,component_appid,authorizer_appid,authorizer_rtoken)
		url='https:// api.weixin.qq.com /cgi-bin/component/api_authorizer_token?component_access_token='+component_token
		body='{"component_appid":"'+component_appid+'","authorizer_appid":"'+authorizer_appid+'","authorizer_refresh_token":"'+authorizer_rtoken+'"}'	
		sent_to_wechat(url,body)
	end
#	def self.get_pre_auth_code(token)
#		uri = URI('https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token='+token)
#                Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
#                   request= Net::HTTP::Post.new(uri,{'Content-Type'=>'application/json'})
#                   request.body='{"component_appid":"'+@@wechat_info.appid+'"}'
#                        puts request.body
#                    response=http.request request
#                    response.body
#                end
#	end	
	def decrypt(text)
      		status = 200
      		text   = Base64.strict_decode64(text)
      		text   = handle_cipher(:decrypt,Base64.strict_decode64(@@wechat_info.encodingkey+'='), text)
      		result = decode(text)
      		content  = result[16...result.length]
      		len_list = content[0...4].unpack("N")
      		xml_len  = len_list[0]
      		xml_content = content[4...4 + xml_len]
      		from_app_id = content[xml_len + 4...content.size]
      		if @@wechat_info.appid != from_app_id
        	puts ("#{__FILE__}:#{__LINE__} Failure because app_id != from_app_id")
        	status = 401
      		end
      		xml_content
    	end
	 def handle_cipher(action, aes_key, text)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.send(action)
        cipher.padding = 0
        cipher.key = aes_key
        cipher.iv  = aes_key[0...16]
        return cipher.update(text) + cipher.final
      end

	def decode(text)
     	 pad = text[-1].ord
      	pad = 0 if (pad < 1 || pad >32 )
      	size = text.size - pad
      	text[0...size]
    end	
end
