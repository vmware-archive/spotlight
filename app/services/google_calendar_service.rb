class GoogleCalendarService
  attr_reader :authorization, :client

  def initialize(options={})
    @authorization = options[:authorization] if options[:authorization]
    @client = Google::Apis::CalendarV3::CalendarService.new
    @client.authorization = @authorization if @authorization
  end

  def list_calendars
    client.list_calendar_lists.items.map do |calendar|
      [calendar.summary, calendar.id]
    end
  end

  def list_events(calendar_id)
    client.list_events(calendar_id,
                        time_min: DateTime.now.rfc3339,
                        order_by: 'startTime',
                        single_events: true, max_results: 3)
           .try(:items)
  end

end
