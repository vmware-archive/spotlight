require 'rails_helper'

describe "the dashboard widget creation", :type => :feature do
  let(:widget_title) {'new widget'}

  before :each do
    Dashboard.create(title: 'Default Dashboard')
  end

  it "must create a widget" do
    visit '/'
    click_link 'New Widget'
    expect(page).to have_css '#qa-new-widget-form'
    fill_in 'Title', :with => widget_title
    fill_in 'Server url', :with => 'https://api.travis-ci.com'
    fill_in 'Project name', :with => 'neo/spotlight'
    fill_in 'Auth key', :with => '5V_zKW9KmdYMpyBR12rtug'

    click_button 'Submit'
    expect(page).to have_content 'Widget was successfully created.'

    visit '/'
    expect(page).to have_content widget_title
    expect(page).to have_selector('.widget', count: 1)
  end

  it "must be able to delete a widget", js: true do
    visit '/'
    click_link 'New Widget'
    fill_in 'Title', :with => widget_title
    fill_in 'Server url', :with => 'https://api.travis-ci.com'
    fill_in 'Project name', :with => 'neo/spotlight'
    fill_in 'Auth key', :with => '5V_zKW9KmdYMpyBR12rtug'
    click_button 'Submit'

    visit '/'
    expect(page).to have_selector('.widget', count: 1)
    click_link 'X'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_selector('.widget', count: 0)
    expect(page).to have_content('successfully deleted.')
  end
end

