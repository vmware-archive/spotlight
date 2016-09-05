require 'google_calendar_service'

class Widget::GcalController < ApplicationController
  def new
    @calendar_list = user_calendar_list
    @widget = Widget.new(category: 'gcal_widget')
  end

  def new_resource
    @resource_list = user_resource_list
    @widget = Widget.new(category: 'gcal_resource_widget')
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

  def create_resource
    @widget = Widget.new(resource_widget_params)
    @widget.dashboard = default_dashboard
    @widget.assign_attributes(config_params)

    if @widget.save
      reset_session
      return redirect_to dashboard_home_path, notice: 'Widget was successfully created.'
    else
      @resource_list = user_resource_list
      return render :new_resource
    end
  end

  private

  def user_calendar_list
    tokens = { access_token: session[:access_token], refresh_token: session[:refresh_token] }
    authorization = GoogleAuthService.new.client(tokens)

    GoogleCalendarService.new(authorization: authorization).list_calendars
  end

  def user_resource_list
    tokens = { access_token: session[:access_token], refresh_token: session[:refresh_token] }
    authorization = GoogleAuthService.new.client(tokens)

    GoogleCalendarService.new(authorization: authorization).list_rooms
  end

  def widget_params
    params.require(:widget).permit(:title, :height, :width).merge({category:'gcal_widget'})
  end

  def resource_widget_params
    params.require(:widget).permit(:title, :height, :width).merge({category:'gcal_resource_widget'})
  end

  def config_params
    params.require(:widget)
        .permit([:calendar_id, :resource_id])
        .merge({
                 access_token: session[:access_token],
                 refresh_token: session[:refresh_token]
               })
  end
end
