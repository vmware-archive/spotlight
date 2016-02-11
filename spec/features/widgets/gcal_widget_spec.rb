require 'rails_helper'

describe 'Google calendar widget spec', :type => :feature do
  let(:widget_title) { 'Calendar' }

  before do
    FactoryGirl.create :dashboard, title: 'Default Dashboard'
  end

  it 'must see a link to google authentication', js: true do
    visit '/widgets/new'

    expect(page).to have_css '#qa-new-widget-form'

    select 'Google Calendar', from: 'Category'
    sleep(0.5)

    expect(page).to have_css '#qa-new-widget-form'
    expect(find('#widget_link_authenticate').text).to eq 'Authenticate with Google'.upcase
    expect(find('#widget_link_authenticate')[:href]).to include '/api/google/login?return_url=/widget/gcal/new'
  end
end