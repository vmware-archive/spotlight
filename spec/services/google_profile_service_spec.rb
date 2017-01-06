require 'rails_helper'

describe GoogleProfileService do
  before do
    VCR.turn_off!
  end

  after do
    VCR.turn_on!
  end

  describe '.get_profile' do
    it 'fetches user from google' do

      stub_request(:get, 'http://www.googleapis.com:443/oauth2/v3/userinfo')
          .with(headers: {'Accept': '*/*',
                          'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                          'Authorization': 'Bearer the-access-token',
                          'Host': 'www.googleapis.com',
                          'User-Agent': 'Ruby'})
          .to_return(
              status: 200,
              body: '{"name": "spotlight", "email": "spotlight@pivotal.io"}',
              headers: {'Content-Type': 'application/json; charset=UTF-8'}
          )

      user_profile = GoogleProfileService.get_profile 'the-access-token'

      expect(user_profile).to eq(name: 'spotlight', email: 'spotlight@pivotal.io')
    end
  end
end
