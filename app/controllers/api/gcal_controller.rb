class Api::GcalController < Api::BaseController
  def show
    @events = calendar_service_for(widget).list_events(widget.calendar_id)
  end

  private

  def widget
    @widget ||= Widget.find_by_uuid(params[:id])
  end

  def calendar_service_for(widget)
    authorization = GoogleAuthService.new.client(access_token: widget.access_token, refresh_token: widget.refresh_token)
    authorization.refresh!

    GoogleCalendarService.new(authorization: authorization)
  end
end