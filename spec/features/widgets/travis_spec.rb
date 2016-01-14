require 'rails_helper'

describe "travis widget spec", :type => :feature do
  let(:repo_description) { 'A kickass dashboard for devshops' }

  before :each do
    d = Dashboard.create(title: 'Default Dashboard')
    w = Widget.create(title: 'neo/spotlight', dashboard: d, category: 'ci_widget')
    w.update(server_type: 'travis_ci',
             server_url: 'https://api.travis-ci.com',
             project_name: 'neo/spotlight',
             auth_key: '5V_zKW9KmdYMpyBR12rtug')
  end

  it "must create a widget", js: true do
    visit '/'
    expect(page).to have_content 'neo/spotlight'
    expect(page).to have_content('Last Build Committer', wait: 5)
  end
end
