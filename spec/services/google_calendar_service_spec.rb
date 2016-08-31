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
        OpenStruct.new(resource_email: 'example@pivotal.io', resource_name: 'fake room name')
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

  describe '#get_room_availability' do
    # TODO
    let(:event_start) { Google::Apis::CalendarV3::EventDateTime.new(date: 1.day.from_now) }
    let(:event_end) { Google::Apis::CalendarV3::EventDateTime.new(date: 2.days.from_now) }
    let(:event) { OpenStruct.new(start: event_start, end: event_end) }
    let(:events) { [ event ] }

    before do
      allow(fake_google_calendar_api_client).to \
        receive_message_chain('list_events.items'){ events }
    end

    context 'day-long events' do
      let(:event_start) { Google::Apis::CalendarV3::EventDateTime.new(date: 1.day.from_now.to_date) }
      let(:event_end) { Google::Apis::CalendarV3::EventDateTime.new(date: 2.days.from_now.to_date) }

      it 'calculates availability correctly' do
        result = subject.get_room_availability 'example@pivotal.io'

        expect(result[:available]).to be_truthy
        expect(result[:next_available_at]).to be_nil
        expect(result[:next_booking_at]).to eq event_start.date.to_time.utc
      end
    end

    context 'non day-long events' do
      context 'when there are no upcoming events for the room' do
        let(:events) { [ ] }

        it 'is available' do
          result = subject.get_room_availability 'example@pivotal.io'

          expect(result[:available]).to be_truthy
          expect(result[:next_available_at]).to be_nil
          expect(result[:next_booking_at]).to be_nil
        end
      end

      context 'when the room is available' do
        let(:event_start) { Google::Apis::CalendarV3::EventDateTime.new(date_time: 1.day.from_now) }
        let(:event_end) { Google::Apis::CalendarV3::EventDateTime.new(date_time: 2.days.from_now) }

        it 'is available' do
          result = subject.get_room_availability 'example@pivotal.io'

          expect(result[:available]).to be_truthy
          expect(result[:next_available_at]).to be_nil
          expect(result[:next_booking_at]).to eq event_start.date_time.utc
        end
      end

      context "when the room isn't available" do
        let(:event_start) { Google::Apis::CalendarV3::EventDateTime.new(date_time: 1.second.ago) }
        let(:event_end) { Google::Apis::CalendarV3::EventDateTime.new(date_time: 2.days.from_now) }

        it 'is available' do
          result = subject.get_room_availability 'example@pivotal.io'

          expect(result[:available]).to be_falsey
          expect(result[:next_available_at]).to eq event_end.date_time.utc
          expect(result[:next_booking_at]).to be_nil
        end
      end
    end

  end
end
