require 'rails_helper'

RSpec.describe Api::GcalController, type: :controller do
  let(:dashboard) { FactoryGirl.create :dashboard, title:'Default Dashboard' }
  let!(:widget) { FactoryGirl.create :widget, :gcal_widget, dashboard: dashboard }

  describe 'GET #show' do
    let(:events) { double }

    before do
      expect_any_instance_of(Signet::OAuth2::Client).to receive(:refresh!)
      expect_any_instance_of(Google::Apis::CalendarV3::CalendarService).to receive_message_chain('list_events.items') { events }

      get :show, id: widget.uuid, format: :json
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns events to controller' do
      expect(assigns(:events)).to eq events
    end
  end
end