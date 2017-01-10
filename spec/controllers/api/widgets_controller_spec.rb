require 'rails_helper'

RSpec.describe Api::WidgetsController, type: :controller do
  let!(:user) { User.create(email: 'spotlight@pivotal.io', auth_token: 'fake-spotlight-token') }
  let(:dashboard) { FactoryGirl.create :dashboard, title:'Default Dashboard' }
  let!(:widget) { FactoryGirl.create :widget,
                    dashboard: dashboard,
                    width: 2,
                    height: 3,
                    position_x: 0,
                    position_y: 0
  }

  before do
    request.headers['X-Spotlight-Token'] = 'fake-spotlight-token'
  end

  describe 'DELETE #widgets' do
    it 'deletes the widget' do
      delete :destroy, { id: widget.id }
      expect(dashboard.widgets.count).to be 0
      expect(response).to have_http_status(:success)
    end

    context 'when the widget does not exist' do
      it 'returns not found status' do
        expect { delete :destroy, { id: -1 } }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end
end
