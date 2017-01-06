class GoogleProfileService
  def self.get_profile access_token
    uri = URI.parse('https://www.googleapis.com/oauth2/v3/userinfo')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"

    res = http.request(req)

    JSON.load(res.body).symbolize_keys
  end
end
