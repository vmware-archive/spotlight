class Api::GcalController < ApplicationController
  def show
    service = calendar_service(widget.access_token, widget.refresh_token)

    @events = service.list_events(widget.calendar_id, time_min: DateTime.now.rfc3339, order_by: 'startTime', single_events: true, max_results: 3 ).try(:items)
  end

  private

  def widget
    @widget ||= Widget.find_by_uuid(params[:id])
  end

  def calendar_service(access_token, refresh_token)
    client = Signet::OAuth2::Client.new({
                                            access_token: access_token,
                                            refresh_token: refresh_token,
                                            client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
                                            client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
                                            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                                        })
    client.refresh!

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    service
  end
end