class Api::GoogleController < ApplicationController
  API_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

  def login
    session[:return_url] = params[:return_url]

    client = Signet::OAuth2::Client.new({
                                            client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
                                            client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
                                            authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
                                            scope: API_SCOPE,
                                            redirect_uri: url_for(action: :callback)
                                        })

    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new({
                                            client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
                                            client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
                                            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                                            redirect_uri: url_for(action: :callback),
                                            code: params[:code]
                                        })

    response = client.fetch_access_token!

    session[:access_token] = response['access_token']
    session[:refresh_token] = response['refresh_token']

    redirect_to session[:return_url]
  end
end