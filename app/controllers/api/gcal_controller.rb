require 'google_calendar_service'

class Api::GcalController < Api::BaseController
  def show
    @events = calendar_service_for(widget).list_events(widget.calendar_id)
  end

  def availability
    @availability = calendar_service_for(widget).get_room_availability(widget.resource_id)
  end

  private

  def widget
    @widget ||= Widget.find_by_uuid(params[:id])
  end

  def calendar_service_for(widget)
    ::GoogleCalendarServiceFactory.new(widget).client
  end
end


