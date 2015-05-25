class Gzh
	@weixin_token='tiandiwang'
	 def  self.check_weixin_legality(timestamp,nonce,signature)
 	 array = [@weixin_token, timestamp, nonce].sort
 	 if signature != Digest::SHA1.hexdigest(array.join)
    		return false
  	else
   		 return true
  	end
	end
	def  self.get_access_token

 uri = URI('https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx3a8121669c822f7f&secret=c39af384f46722e3dfa527c255529011')

Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Get.new uri

  response = http.request request 

  response_json=JSON.parse(response.body)  

  return response_json["access_token"]  
end

end

	def  self.menu_to_json
      str='{"button":'+
      '[{"type":"view","name":"shouquan","url":'+
        '"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx3a8121669c822f7f&redirect_uri=http://shop.29mins.com/gzhs/get_code&response_type=code&scope=snsapi_userinfo&state=200"}]}'
        puts str

      return str
  end
end
