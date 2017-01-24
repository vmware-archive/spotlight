require 'rails_helper'

RSpec.describe 'creating an OpenAir widget', type: :feature do
  let!(:user) { User.create email: 'spotlight@pivotal.io', auth_token: 'fake-auth-token' }
  let(:widget_title) { 'Timesheets' }

  before do
    Dashboard.create title: 'Default Dashboard'
  end

  it 'creates an OpenAir widget', js: true do
    visit home_page
    login_to_dashboard

    click_add_widget

    select 'OpenAir Timesheet Status', from: 'Category'

    fill_in 'Title', with: widget_title
    fill_in 'Username', with: 'username'
    fill_in 'Password', with: 'password'
    fill_in 'Company', with: 'company'
    fill_in 'Client', with: 'client'
    fill_in 'Key', with: 'key'
    fill_in 'Url', with: 'url'
    fill_in 'User emails', with: 'user1@example.com, user2@example.com'

    click_button 'Submit'

    expect(page).to have_content widget_title
  end
end
