require 'rails_helper'

RSpec.describe GoogleCalendarService do
  let(:calendar_title) { 'BBQ' }
  let(:calendar_id) { 'some_id' }
  let(:service) { double }

  before do
    expect_any_instance_of(GoogleCalendarService).to receive(:service).and_return(service)
  end

  describe '#list_calendars' do
    let(:calendars) do
      [
        OpenStruct.new(summary: calendar_title, id: calendar_id)
      ]
    end

    before do
      allow(service).to receive_message_chain('list_calendar_lists.items'){ calendars }
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
      allow(service).to receive_message_chain('list_events.items'){ events }
    end

    it 'returns list of events' do
      result = subject.list_events(calendar_id)
      expect(result.count).to eq 1
      expect(result.first).to eq event
    end
  end
end