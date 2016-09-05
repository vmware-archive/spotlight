require 'rails_helper'

def json_get(path)
  result = RestClient.get("http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}", { accept: :json })
  JSON.parse(result.body, symbolize_names: true)
end

describe 'Google calendar widget spec', :type => :feature, foreman_frontend: true do
  let(:widget_title) { 'Calendar' }

  before do
    FactoryGirl.create :dashboard, title: 'Default Dashboard'
  end

  it 'renders the calendar widget and shows upcoming events', js: true do
    VCR.use_cassette('google oauth with calendar', :allow_playback_repeats => true, match_requests_on: [:method, VCR.request_matchers.uri_without_param(:timeMin)]) do
      visit '/api/dashboards/'
      expect(page).to_not have_content('gcal_widget')

      visit '/widgets/new'

      expect(page).to have_css '#qa-new-widget-form'


      select 'Google Calendar', from: 'Category'

      expect(page).to have_css '#qa-new-widget-form'
      expect(find('#widget_link_authenticate').text).to eq 'Authenticate with Google'.upcase
      expect(find('#widget_link_authenticate')[:href]).to include '/api/google/login?return_url=/widget/gcal/new'


      google_auth_url = "https://accounts.google.com:443/o/oauth2/auth"
      query_params = "?grant_type=authorization_code&code=4%2F0eadCm5saT2_PNcIjKRlOg4x9cAG8cXR7ySP--QG9x4&redirect_uri=http%3A%2F%2F127.0.0.1%3A8200%2Fapi%2Fgoogle%2Fcallback&client_id=207948129196-i2m0i0a5rf5p8ats5148smvdpl33rtse.apps.googleusercontent.com&client_secret=LN6ejsYaA05w4zmLrlIwBRBn"
      callback_url = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/api/google/callback#{query_params}"
      proxy.stub(google_auth_url).and_return(redirect_to: callback_url)

      click_on 'Authenticate with Google'

      fill_in 'Title', with: 'A Title'
      select 'STUBBED CALENDAR NAME', from: 'Calendar'

      click_on 'Submit'

      sleep 2
      expect(page.body).to match 'OUR STUBBED EVENT'
    end
  end

  it 'renders the calendar widget and shows availability', js: true do
    VCR.use_cassette('google oauth with calendar', :allow_playback_repeats => true, match_requests_on: [:method, VCR.request_matchers.uri_without_param(:timeMin)]) do
      visit '/api/dashboards/'
      expect(page).to_not have_content('gcal_widget')

      visit '/widgets/new'

      expect(page).to have_css '#qa-new-widget-form'


      select 'Google Calendar Resource', from: 'Category'

      expect(page).to have_css '#qa-new-widget-form'
      expect(find('#widget_link_authenticate').text).to eq 'Authenticate with Google'.upcase
      expect(find('#widget_link_authenticate')[:href]).to include '/api/google/login?return_url=/widget/gcal_resource/new'


      google_auth_url = "https://accounts.google.com:443/o/oauth2/auth"
      query_params = "?grant_type=authorization_code&code=4%2F0eadCm5saT2_PNcIjKRlOg4x9cAG8cXR7ySP--QG9x4&redirect_uri=http%3A%2F%2F127.0.0.1%3A8200%2Fapi%2Fgoogle%2Fcallback&client_id=207948129196-i2m0i0a5rf5p8ats5148smvdpl33rtse.apps.googleusercontent.com&client_secret=LN6ejsYaA05w4zmLrlIwBRBn"
      callback_url = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/api/google/callback#{query_params}"
      proxy.stub(google_auth_url).and_return(redirect_to: callback_url)

      click_on 'Authenticate with Google'

      fill_in 'Title', with: 'A Title'
      select 'STUBBED RESOURCE NAME', from: 'Resource'

      click_on 'Submit'

      expect(page.body).to match 'STUBBED RESOURCE NAME'
    end
  end

end
