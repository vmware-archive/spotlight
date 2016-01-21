require 'rails_helper'

RSpec.describe Api::DashboardsController, type: :controller do
  let(:dashboard) { FactoryGirl.create :dashboard, title:'Default Dashboard' }
  let(:widget) { FactoryGirl.create :widget,
                    dashboard: dashboard,
                    width: 2,
                    height: 3,
                    position_x: 0,
                    position_y: 0
  }

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

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "update the widget layout" do
      updated_widget = widget.reload

      expect(updated_widget.width).to eq 3
      expect(updated_widget.height).to eq 4
      expect(updated_widget.position_x).to eq 1
      expect(updated_widget.position_y).to eq 1
    end
  end
end
