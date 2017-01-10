require 'rails_helper'

RSpec.describe Api::BaseController, type: :controller do
  let(:auth_token) { 'fake-spotlight-token' }

  controller do
    def index
      head :ok
    end
  end

  context 'X-Spotlight-Token is included' do
    before do
      request.headers['X-Spotlight-Token'] = auth_token
    end

    context 'token belongs to a user' do
      let!(:user) do
        User.create(
            email: 'spotlight@pivotal.io',
            auth_token: auth_token
        )
      end

      it 'returns 200' do
        get :index

        expect(response).to be_ok
      end
    end

    context 'token does not belong to any user' do
      it 'returns 403' do
        get :index

        expect(response).to be_forbidden
      end
    end
  end

  context 'X-Spotlight-Token is not included' do
    it 'returns 403' do
      get :index

      expect(response).to be_forbidden
    end
  end
end

