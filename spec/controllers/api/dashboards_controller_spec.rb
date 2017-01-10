require 'rails_helper'

RSpec.describe Api::DashboardsController, type: :controller do
  let!(:user) { User.create(email: 'spotlight@pivotal.io', auth_token: 'fake-spotlight-token') }
  let(:dashboard) { FactoryGirl.create :dashboard, title:'Default Dashboard' }
  let!(:widget) { FactoryGirl.create :widget,
                    dashboard: dashboard,
                    width: 2,
                    height: 3,
                    position_x: 0,
                    position_y: 0
  }

  shared_examples 'returns success' do
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  before do
    request.headers['X-Spotlight-Token'] = 'fake-spotlight-token'
  end

  describe 'GET #index' do
    before do
      get :index, format: :json
    end

    it_behaves_like 'returns success'

    it 'returns renders `show`' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #show' do
    render_views

    before do
      get :show, id: 'default', format: :json
    end

    it_behaves_like 'returns success'

    it 'returns list of existing widgets' do
      result = JSON.parse(response.body)

      expect(result['widgets'].count).to eq 1
      expect(result['widgets'].first.keys).to eq %w(uuid title category layout widgetPath)
      expect(result['widgets'].first['uuid']).to eq widget.uuid
      expect(result['widgets'].first['category']).to eq widget.category.to_s
      expect(result['widgets'].first['layout'].keys).to eq %w(x y h w)
      expect(result['widgets'].first['widgetPath']).to eq api_widget_path(widget.id)
    end
  end

  describe "PUT #layout" do
    let(:layout) do
      {
        layout: [
          {'i' => widget.uuid, 'x' => 1, 'y' => 1, 'w' => 3, 'h' => 4}
        ]
      }
    end

    before do
      put :layout, layout.to_json, format: :json, dashboard_id: dashboard.id
    end

    it_behaves_like 'returns success'

    it "update the widget layout" do
      updated_widget = widget.reload

      expect(updated_widget.width).to eq 3
      expect(updated_widget.height).to eq 4
      expect(updated_widget.position_x).to eq 1
      expect(updated_widget.position_y).to eq 1
    end
  end
end
