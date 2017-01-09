require 'rails_helper'

describe GoogleTokenInfoService do
  subject { GoogleTokenInfoService.new(mock_api_client) }
  let(:mock_api_client) { instance_double('Google::Apis::Oauth2V2::Oauth2Service') }

  describe '.get_token_info' do
    specify do
      expect(mock_api_client).to receive(:tokeninfo).with(id_token: 'FAKE_ID_TOKEN')

      subject.get_token_info 'FAKE_ID_TOKEN'
    end
  end
end
