class Api::GoogleController < Api::BaseController
  API_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

  def login
    session[:return_url] = params[:return_url]

    client = Signet::OAuth2::Client.new( oauth2_config.merge({scope: API_SCOPE}) )

    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new( oauth2_config.merge({code: params[:code]}) )

    response = client.fetch_access_token!

    session[:access_token] = response['access_token']
    session[:refresh_token] = response['refresh_token']

    redirect_to session[:return_url]
  end

  private

  def oauth2_config
    {
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(action: :callback),
    }
  end
end