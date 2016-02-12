class Widget::GcalController < ApplicationController
  def new
    @calendar_list = user_calendar_list
    @widget = Widget.new(category: 'gcal_widget')
  end

  def create
    @widget = Widget.new(widget_params)
    @widget.dashboard = default_dashboard
    @widget.assign_attributes(config_params)

    if @widget.save
      reset_session
      return redirect_to dashboard_home_path, notice: 'Widget was successfully created.'
    else
      @calendar_list = user_calendar_list
      return render :new
    end
  end

  private

  def user_calendar_list
    tokens = { access_token: session[:access_token], refresh_token: session[:refresh_token] }
    authorization = GoogleAuthService.new.client(tokens)

    GoogleCalendarService.new(authorization: authorization).list_calendars
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
end