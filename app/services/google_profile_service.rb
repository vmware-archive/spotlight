class GoogleProfileService
  def self.get_profile access_token
    uri = URI.parse('https://www.googleapis.com/oauth2/v3/userinfo')

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"

    res = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(req)
    }

    JSON.load(res.body).symbolize_keys
  end
end
