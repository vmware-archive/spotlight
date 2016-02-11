class Widget::GcalController < ApplicationController
  def new
    @calendar_list = user_calendar_list(session[:access_token], session[:refresh_token])
    @widget = Widget.new(category: 'gcal_widget')
  end

  def create
    @widget = Widget.new(widget_params)
    @widget.dashboard = default_dashboard
    @widget.assign_attributes(config_params)

    if @widget.save
      reset_session
      return redirect_to dashboards_path, notice: 'Widget was successfully created.'
    else
      @calendar_list = user_calendar_list(session[:access_token], session[:refresh_token])
      return render :new
    end
  end

  private

  def user_calendar_list(access_token, refresh_token)
    client = Signet::OAuth2::Client.new({
                                            access_token: access_token,
                                            refresh_token: refresh_token,
                                            client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
                                            client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
                                            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                                        })

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    service.list_calendar_lists.items.map do |calendar|
      [calendar.summary, calendar.id]
    end
  end

  def widget_params
    params.require(:widget).permit(:title, :height, :width).merge({category:'gcal_widget'})
  end

  def config_params
    params.require(:widget)
        .permit(:calendar_id)
        .merge({
                 access_token: session[:access_token],
                 refresh_token: session[:refresh_token]
               })
  end

  def default_dashboard
    Dashboard.first
  end
end