require 'rails_helper'

RSpec.describe Api::GcalController, type: :controller do
  let(:dashboard) { FactoryGirl.create :dashboard, title:'Default Dashboard' }
  let!(:widget) { FactoryGirl.create :widget, :gcal_widget, dashboard: dashboard }

  let(:events) { double }
  let(:authorization) { double }

  before do
    allow(authorization).to receive(:refresh!).and_return(true)
    allow_any_instance_of(GoogleAuthService).to receive(:client).and_return(authorization)
    allow_any_instance_of(GoogleCalendarService).to receive(:list_events).with(widget.calendar_id).and_return(events)
  end

  describe 'GET #show' do
    before do
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

