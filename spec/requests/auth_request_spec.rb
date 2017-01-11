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

describe 'POST /login' do
  let!(:user) { User.create email: 'spotlight@pivotal.io', auth_token: 'fake-auth-token' }
  let(:auth_token) { 'fake-auth-token' }
  let(:redirect_url) { new_widget_path }

  context 'when auth_token is included' do
    context 'when auth_token belongs to a user' do

      context 'when redirect url is specified' do

        it 'redirects the user to the given redirect url' do
          post '/login', {auth_token: auth_token, redirect_url: redirect_url}

          expect(response).to be_redirect
          expect(response).to redirect_to redirect_url

          get redirect_url
          expect(response).to be_ok
        end
      end

      context 'when redirect url is not specified' do
        it 'responds with bad request' do
          post '/login', {auth_token: auth_token}

          expect(response).to be_bad_request
        end
      end
    end

    context 'when auth_token does not belong to a user' do
      let(:auth_token) { 'another_auth_token' }

      it 'redirects the user to the dashboard' do
        post '/login', {auth_token: auth_token, redirect_url: redirect_url}

        expect(response).to be_redirect
        expect(response).to redirect_to ENV.fetch('WEB_HOST')
      end
    end
  end

  context 'when auth_token is not included' do
    it 'redirects the user to the dashboard' do
      post '/login', {redirect_url: redirect_url}

      expect(response).to be_bad_request
    end
  end
end
