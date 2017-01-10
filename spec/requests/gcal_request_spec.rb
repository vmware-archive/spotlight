require "rails_helper"

def format(d)
  d = d.date_time unless d.class == DateTime
  d.strftime("%Y-%m-%dT%H:%M:%SZ")
end

RSpec.describe Api::GcalController do
  let!(:user) { User.create(email: 'spotlight@pivotal.io', auth_token: 'fake-spotlight-token') }
  let(:dashboard) { FactoryGirl.create :dashboard, title:'Default Dashboard' }

  let(:e1start) { Google::Apis::CalendarV3::EventDateTime.new(date_time: 1.hour.from_now) }
  let(:e1end)   { Google::Apis::CalendarV3::EventDateTime.new(date_time: 2.hours.from_now) }
  let(:e2start) { Google::Apis::CalendarV3::EventDateTime.new(date_time: 3.hours.from_now) }
  let(:e2end)   { Google::Apis::CalendarV3::EventDateTime.new(date_time: 4.hours.from_now) }
  let(:events) do
    [
      Google::Apis::CalendarV3::Event.new(title: 'Event One', summary: 'Event One Summary', start: e1start, end: e1end),
      Google::Apis::CalendarV3::Event.new(title: 'Event Two', summary: 'Event Two Summary', start: e2start, end: e2end)
    ]
  end

  before do
    allow_any_instance_of(GoogleCalendarServiceFactory).to receive(:client).and_return(
      double list_events: events
    )
  end

  describe 'GET #availability' do
    let!(:widget) { FactoryGirl.create :widget, :gcal_resource_widget, dashboard: dashboard }

    let(:availability) do 
      {
        available: true,
        next_booking_at: 'some date',
        next_available_at: 'another date'
      }
    end

    before do
      allow_any_instance_of(GoogleCalendarServiceFactory).to receive(:client).and_return(
        double get_room_availability: availability
      )
    end

    it 'returns the availability' do
      headers = {
          'ACCEPT': 'application/json',
          'X-Spotlight-Token': 'fake-spotlight-token'
      }

      get "/api/gcal/#{widget.uuid}/availability", nil, headers
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed[:available]).to be_truthy
      expect(parsed[:next_booking_at]).to eq 'some date'
      expect(parsed[:next_available_at]).to eq 'another date'
    end
  end

  describe 'GET #show' do
    let!(:widget) { FactoryGirl.create :widget, :gcal_widget, dashboard: dashboard }

    it 'returns the information about the calendar' do
      headers = {
          'ACCEPT': 'application/json',
          'X-Spotlight-Token': 'fake-spotlight-token'
      }

      get "/api/gcal/#{widget.uuid}", nil, headers
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed[:events]).to eq [
        {:title=>"Event One Summary",
         :start=> format(e1start),
         :end=> format(e1end)},

         {:title=>"Event Two Summary",
          :start=>format(e2start),
          :end=>format(e2end)}
      ]
    end
  end
end
