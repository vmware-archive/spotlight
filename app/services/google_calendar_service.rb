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
    directory_api_client.list_calendar_resources('my_customer').items.map do |room|
      [room.room_name, room.room_email]
    end
  end


end
