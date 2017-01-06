require 'rails_helper'

describe '/login' do
  describe 'POST /' do
    let(:email) { 'spotlight@pivotal.io' }
    let(:user_data) {
      {
          name: 'spotlight',
          email: email,
      }
    }

    it 'creates a new user with unique id' do
      expect(GoogleProfileService).to receive(:get_profile)
                                          .with('the-access-token')
                                          .and_return(user_data)

      post '/login', {access_token: 'the-access-token'}, as: :json

      expect(response).to be_created

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:auth_token]).not_to be_nil

      user = User.last
      expect(user.name).to eq('spotlight')
      expect(user.email).to eq('spotlight@pivotal.io')
      expect(user.auth_token).not_to be_nil
    end

    shared_examples 'access token is invalid' do
      it 'forid the user from creation' do
        expect(GoogleProfileService).to receive(:get_profile)
                                            .with('the-access-token')
                                            .and_return(user_data)

        post '/login', {access_token: 'the-access-token'}, as: :json

        expect(response).to be_forbidden
      end
    end

    context 'when token belongs to a non pivotal user' do
      let(:email) { 'spotlight@random.io' }

      it_behaves_like 'access token is invalid'
    end

    context 'when token is not a valid google auth token' do
      let(:user_data) { {} }

      it_behaves_like 'access token is invalid'
    end

    context 'when email already exists' do
      it 'does not create a new user' do
        User.create! name: 'spotlight', email: 'spotlight@pivotal.io'

        expect(GoogleProfileService).to receive(:get_profile)
                                            .with('the-access-token')
                                            .and_return(user_data)

        expect { post '/login', {access_token: 'the-access-token'}, as: :json }.not_to change { User.count }
      end
    end
  end
end
