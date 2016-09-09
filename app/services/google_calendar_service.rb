class GoogleCalendarService
  attr_reader :authorization, :calendar_api_client, :directory_api_client

  def initialize(options={})
    @authorization = options[:authorization] if options[:authorization]

    @calendar_api_client = Google::Apis::CalendarV3::CalendarService.new
    @calendar_api_client.authorization = @authorization if @authorization

    @directory_api_client = Google::Apis::AdminDirectoryV1::DirectoryService.new
    @directory_api_client.authorization = @authorization if @authorization
  end

  def list_calendars
    calendar_api_client.list_calendar_lists.items.map do |calendar|
      [calendar.summary, calendar.id]
    end
  end

  def list_events(calendar_id)
    calendar_api_client.list_events(calendar_id,
                        time_min: DateTime.now.rfc3339,
                        order_by: 'startTime',
                        single_events: true, max_results: 3)
           .try(:items)
  end

  def list_rooms
    directory_api_client.list_calendar_resources('my_customer').items.map do |resource|
      [resource.resource_name, resource.resource_email]
    end.sort_by {|pair| pair[0]}
  end

  def get_room_availability room_email
    upcoming_events = list_events(room_email) || []

    if upcoming_events.length == 0
      available = true
      next_available_at = nil
      next_booking_at = nil
    else
      event = upcoming_events.first
      event_start = (event.start.date_time || event.start.date).to_time.utc
      event_end = (event.end.date_time || event.end.date).to_time.utc
      time_span = event_start..event_end

      available = ! time_span.include?(Time.now.utc)
      next_available_at = available ? nil : event_end
      next_booking_at = available ? event_start : nil
    end

    {
      available: available,
      next_booking_at: next_booking_at,
      next_available_at: next_available_at
    }
  end

end

class GoogleCalendarServiceFactory
  attr_reader :client

  def initialize widget
    @widget = widget
  end

  def client
    authorization = GoogleAuthService.new.client(
      access_token: @widget.access_token,
      refresh_token: @widget.refresh_token)
    authorization.refresh! if @widget.refresh_token.present?

    GoogleCalendarService.new(authorization: authorization)
  end
end
