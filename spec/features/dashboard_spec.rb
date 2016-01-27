require 'rails_helper'

def get_offset(node)
  node[:style]
    .match(/translate\((.*)px, (.*)px\)/)[1..2]
    .map(&:to_i)
end

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
      FactoryGirl.create(:widget, dashboard: Dashboard.first, height: 2, width: 2, position_x: 0, position_y: 0)
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
      vertical_offset = 2
      horizontal_offset = 1

      new_widget = FactoryGirl.create(:widget, dashboard: Dashboard.first,
        position_x: horizontal_offset,
        position_y: vertical_offset,
        height: 4, width: 4 )

      visit '/'

      ci_widget_node = page.first(:css, ".ci-widget[data-uuid='#{new_widget.uuid}']")
      widget_node = ci_widget_node.find(:xpath, '..')
      #widget is the parent div of the ci_widget.

      position_x, position_y = get_offset(widget_node)
      window_width = page.current_window.size[0]

      row_height = 100
      column_count = 12
      delta = 10
      expect(position_x).to be_within(delta).of(window_width/column_count * horizontal_offset)
      expect(position_y).to be_within(delta).of(row_height * vertical_offset)
    end

    it 'saves the layout changes and redirects to dashboards path', js:true do
      visit '/'
      click_link 'edit'
      sleep(1)

      widget = page.first('.widget')
      original_offsets = get_offset(widget)

      target = page.first('.save-button')
      widget.drag_to(target)

      after_drag_offsets = get_offset(widget)
      expect(original_offsets).to_not eq after_drag_offsets

      click_link 'save'
      expect(page.current_path).to eq '/dashboards'

      sleep(1)
      after_save_offsets = get_offset page.first('.widget')
      expect(after_save_offsets).to eq after_drag_offsets

    end
  end
end

