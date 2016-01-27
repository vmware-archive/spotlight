require 'rails_helper'

describe "the dashboard widget creation", :type => :feature do
  let(:widget_title) {'new widget'}

  before do
    Dashboard.create(title: 'Default Dashboard')
  end

  it "must create a widget", js: true do
    visit '/'
    click_link 'edit'
    click_link 'add'
    expect(page).to have_css '#qa-new-widget-form'

    select 'Continuous Integration Status', from: 'Category'
    sleep(0.5)

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

  context 'has existing widget' do
    before do
      FactoryGirl.create(:widget, dashboard: Dashboard.first, height: 2)
    end

    it "must be able to delete a widget", js: true do
      visit '/'
      expect(page).to have_selector('.widget', count: 1)
      click_link 'edit'
      click_link 'delete'
      sleep(3)
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector('.widget', count: 0)
      expect(page).to have_content('successfully deleted.')
    end

    it 'renders the widget in the correct position', js: true do
      new_widget = FactoryGirl.create(:widget, dashboard: Dashboard.first,
        position_x: 2, position_y: 1,
        height: 4, width: 5 )
      row_height = 100;
      delta = 10

      visit '/'

      ci_widget_node = page.first(:css, ".ci-widget[data-uuid='#{new_widget.uuid}']")
      widget_node = ci_widget_node.find(:xpath, '..')
      #widget is the parent div of the ci_widget.

      position_x, position_y = widget_node[:style]
                                  .match(/translate\((.*)px, (.*)px\)/)[1..2]
                                  .map(&:to_i)
      window_width = page.current_window.size[0]

      expect(position_x).to be_within(delta).of(window_width/12 * 2)
      expect(position_y).to be_within(delta).of(row_height * 2)
    end
  end
end

