require 'rails_helper'

describe 'POST /get_auth_token' do
  before do
    ENV['GOOGLE_API_CLIENT_ID'] = 'fake-client-id.apps.googleusercontent.com'
  end

  context 'when the id token is valid' do
    let(:email) { 'spotlight@pivotal.io' }
    let(:audience) { 'fake-client-id.apps.googleusercontent.com' }
    let(:id_token) { 'fake-id-token' }
    let(:token_info) do
      Google::Apis::Oauth2V2::Tokeninfo.new(
          email: email,
          audience: audience
      )
    end

    before do
      expect_any_instance_of(GoogleTokenInfoService).to receive(:get_token_info)
                                                            .with(id_token)
                                                            .and_return(token_info)
    end

    it 'creates a new user' do
      post '/get_auth_token', {id_token: id_token}, as: :json

      expect(response).to be_created

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:auth_token]).not_to be_nil

      user = User.last
      expect(user.email).to eq('spotlight@pivotal.io')
      expect(user.auth_token).not_to be_nil
    end

    context 'when user with email address already exists' do
      it 'does not create a new user' do
        User.create! email: 'spotlight@pivotal.io'

        expect { post '/get_auth_token', {id_token: id_token}, as: :json }.not_to change { User.count }
      end
    end

    context 'when token belongs to a non-Pivotal user' do
      let(:email) { 'spotlight@random.io' }

      it 'returns 403 forbidden' do
        post '/get_auth_token', {id_token: id_token}, as: :json

        expect(response).to be_forbidden
      end
    end

    context 'when token audience is another client' do
      let(:audience) { 'another-client-id.apps.googleusercontent.com' }

      it 'returns 403 forbidden' do
        post '/get_auth_token', {id_token: id_token}, as: :json

        expect(response).to be_forbidden
      end
    end
  end

  context 'when the id token is not valid' do
    let(:id_token) { 'invalid-id-token' }

    it 'returns 403 forbidden' do
      expect_any_instance_of(GoogleTokenInfoService).to receive(:get_token_info)
                                                            .with(id_token)
                                                            .and_raise(Google::Apis::ClientError.new('Invalid token'))

      post '/get_auth_token', {id_token: id_token}, as: :json

      expect(response).to be_forbidden
    end
  end
end
