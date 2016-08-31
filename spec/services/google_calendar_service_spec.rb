require 'rails_helper'

RSpec.describe GoogleCalendarService do
  let(:calendar_title) { 'BBQ' }
  let(:calendar_id) { 'some_id' }
  let(:fake_google_calendar_api_client) { double }
  let(:fake_google_admin_directory_api_client) { double }

  before do
    allow_any_instance_of(GoogleCalendarService).to receive(:calendar_api_client).and_return(fake_google_calendar_api_client)
    allow_any_instance_of(GoogleCalendarService).to receive(:directory_api_client).and_return(fake_google_admin_directory_api_client)
  end

  describe '#list_calendars' do
    let(:calendars) do
      [
        OpenStruct.new(summary: calendar_title, id: calendar_id)
      ]
    end

    before do
      allow(fake_google_calendar_api_client).to receive_message_chain('list_calendar_lists.items'){ calendars }
    end

    it 'returns list of calendars' do
      result = subject.list_calendars
      expect(result.count).to eq 1
      expect(result.first).to eq [calendar_title, calendar_id]
    end
  end

  describe '#list_events' do
    let(:event) { double }
    let(:events) do
      [ event ]
    end

    before do
      allow(fake_google_calendar_api_client).to receive_message_chain('list_events.items'){ events }
    end

    it 'returns list of events' do
      result = subject.list_events(calendar_id)
      expect(result.count).to eq 1
      expect(result.first).to eq event
    end
  end

  describe '#list_rooms' do
    let(:rooms) do
      [
        OpenStruct.new(room_email: 'example@pivotal.io', room_name: 'fake room name')
      ]
    end

    before do
      expect(fake_google_admin_directory_api_client).to \
        receive(:list_calendar_resources).with('my_customer')

      allow(fake_google_admin_directory_api_client).to \
        receive_message_chain('list_calendar_resources.items'){ rooms }
    end

    it 'returns the list of rooms' do
      result = subject.list_rooms
      expected_room_name, expected_room_email= result[0]

      expect(expected_room_email).to eq('example@pivotal.io')
      expect(expected_room_name).to eq('fake room name')
    end
  end
end
