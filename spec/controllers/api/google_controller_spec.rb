require 'rails_helper'

RSpec.describe Api::GoogleController, type: :controller do
  let!(:user) { User.create(email: 'spotlight@pivotal.io', auth_token: 'fake-spotlight-token') }

  before do
    request.headers['X-Spotlight-Token'] = 'fake-spotlight-token'
  end

  describe 'GET #login' do
    let(:authorization_url) { 'https://accounts.google.com/o/oauth2/auth' }

    it 'redirects to authorization URL' do
      expect_any_instance_of(Signet::OAuth2::Client).to receive_message_chain("authorization_uri.to_s") { authorization_url }

      get :login

      expect(response).to redirect_to authorization_url
    end
  end

  describe 'GET #callback' do
    let(:request_token) { 'request_token' }
    let(:access_token) { 'access_token' }
    let(:refresh_token) { 'refresh_token' }
    let!(:return_url) { '/widget/gcal/new' }

    let(:oauth2_response) do
      {
        'access_token' => access_token,
        'refresh_token' => refresh_token
      }
    end

    before do
      session[:return_url] = return_url
    end

    it 'redirects to return url' do
      expect_any_instance_of(Signet::OAuth2::Client).to receive(:fetch_access_token!).and_return(oauth2_response)

      get :callback, code: request_token

      expect(session[:access_token]).to eq access_token
      expect(session[:refresh_token]).to eq refresh_token
      expect(response).to redirect_to return_url
    end
  end
end