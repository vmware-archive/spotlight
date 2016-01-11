require 'rails_helper'

describe "the dashboard widget creation", :type => :feature do
  before :each do
    Dashboard.create(title: 'Default Dashboard')
  end

  it "must create a widget" do
    visit '/'
    click_link 'New Widget'
    expect(page).to have_css '#qa-new-widget-form'
    fill_in 'Title', :with => 'neo/spotlight'
    click_button 'Submit'
    visit '/'
    expect(page).to have_content 'neo/spotlight'
    expect(page).to have_selector('.widget', count: 1)
  end
end

