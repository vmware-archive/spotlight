class Api::GoogleController < Api::BaseController
  API_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

  def login
    session[:return_url] = params[:return_url]

    redirect_to auth_service.get_authorization_uri(redirect_uri: callback_url, scope: API_SCOPE)
  end

  def callback
    tokens = auth_service.fetch_tokens(redirect_uri: callback_url, scope: API_SCOPE, code: params[:code])

    if tokens
      session[:access_token] = tokens[:access_token]
      session[:refresh_token] = tokens[:refresh_token]
    end

    redirect_to session[:return_url] || dashboards_path
  end

  private

  def callback_url
    url_for(action: :callback)
  end

  def auth_service
    @service ||= GoogleAuthService.new
  end
end