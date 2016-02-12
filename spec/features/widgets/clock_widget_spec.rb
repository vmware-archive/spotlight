require 'rails_helper'

describe "clock widget spec", :type => :feature do
  let(:widget_title) { 'Clock' }

  before do
    FactoryGirl.create :dashboard, title: 'Default Dashboard'
  end

  it "must create a widget", js: true do
    visit home_page
    click_link 'edit'
    click_link 'add'
    expect(page).to have_css '#qa-new-widget-form'

    select 'Clock', from: 'Category'
    sleep(0.5)

    fill_in 'Title', :with => widget_title

    click_button 'Submit'
    expect(page).to have_css '.edit-button' # goes back to read mode

    expect(Widget.count).to eq 1
    expect(Widget.first.category).to eq 'clock_widget'
  end
end