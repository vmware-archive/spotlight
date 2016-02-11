require 'rails_helper'

RSpec.describe Widget::GcalController, type: :controller do
  let!(:dashboard) { FactoryGirl.create :dashboard, title:'Default Dashboard' }

  let(:access_token) { 'access_token' }
  let(:refresh_token) { 'refresh_token' }

  before do
    session[:access_token] = access_token
    session[:refresh_token] = refresh_token
  end

  describe 'GET #new' do
    let(:calendars) { double }

    it 'returns http success' do
      expect_any_instance_of(Widget::GcalController).to receive(:user_calendar_list)
                                                            .with(access_token, refresh_token)
                                                            .and_return(calendars)

      get :new

      expect(assigns(:calendar_list)).to eq calendars
      expect(assigns(:widget)).to be_a Widget
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:calendar_id) { 'office_calendar' }
    let(:post_data) do
      {
        widget: {
          title: 'Office Calendar',
          height: 3,
          width: 3,
          calendar_id: calendar_id
        }
      }
    end

    it 'creates new widget' do
      post :create, post_data

      expect(Widget.count).to eq 1

      widget = Widget.first
      expect(widget.access_token).to eq access_token
      expect(widget.refresh_token).to eq refresh_token
      expect(widget.calendar_id).to eq calendar_id

      expect(response).to redirect_to(dashboards_path)
    end
  end
end