class GoogleCalendarService
  attr_reader :authorization

  def initialize(options={})
    @authorization = options[:authorization] if options[:authorization]
  end

  def list_calendars
    service.list_calendar_lists.items.map do |calendar|
      [calendar.summary, calendar.id]
    end
  end

  def list_events(calendar_id)
    service.list_events(calendar_id,
                        time_min: DateTime.now.rfc3339,
                        order_by: 'startTime',
                        single_events: true, max_results: 3)
           .try(:items)
  end

  private

  def service
    unless @service
      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.authorization = authorization
    end

    @service
  end
end