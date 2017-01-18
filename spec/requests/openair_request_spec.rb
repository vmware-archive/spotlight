require 'rails_helper'

describe 'GET #show' do
  let!(:user) { User.create(email: 'spotlight@pivotal.io', auth_token: 'fake-spotlight-token') }
  let!(:widget) do
    FactoryGirl.create :widget,
                       :openair_widget,
                       :with_default_dashboard,
                       url: 'https://sandbox.openair.com',
                       user_ids: [1, 2]
  end
  let(:headers) do
    {
        'Accept': 'application/json',
        'X-Spotlight-Token': 'fake-spotlight-token'
    }
  end

  it 'returns the overall submission status of the timesheets for the previous week' do
    Timecop.travel(Date.new(2016, 6, 6)) do
      VCR.use_cassette('openair', match_requests_on: [:uri, :method, :body]) do
        get "/api/openair/#{widget.uuid}", nil, headers

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_response).to eq({status: 'submitted'})
      end
    end
  end
end
