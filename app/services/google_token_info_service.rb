class GoogleTokenInfoService
  def initialize(oauth_api_client=Google::Apis::Oauth2V2::Oauth2Service.new)
    @oauth_api_client = oauth_api_client
  end

  def get_token_info(id_token)
    @oauth_api_client.tokeninfo(id_token: id_token)
  end
end
