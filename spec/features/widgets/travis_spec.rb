require 'rails_helper'

describe "travis widget spec", :type => :feature do
  let(:repo_description) { 'A kickass dashboard for devshops' }

  before :each do
    d = Dashboard.create(title: 'Default Dashboard')
    w = CiWidget.create(title: 'neo/spotlight', dashboard: d)
    w.update(travis_url: 'https://api.travis-ci.com/repos/neo/spotlight', travis_auth_key: '5V_zKW9KmdYMpyBR12rtug')
  end

  it "must create a widget", js: true do
    visit '/'
    expect(page).to have_content 'neo/spotlight'
    # checking the contents of the ajax request
    expect(page).to have_content(repo_description, wait: 5)
  end
end
