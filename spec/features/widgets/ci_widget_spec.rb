require 'rails_helper'

describe "travis widget spec", :type => :feature do
  let(:server_url) { 'https://api.travis-ci.com' }
  let(:auth_key) { 'auth_key' }
  let(:project_name) { 'the_resistance/x_wing' }
  let(:opts) do
    {
      server_url: server_url,
      auth_key: auth_key,
      project_name: project_name,
      server_type: 'travis_ci'
    }
  end

  let(:build_id) { 12345 }
  let(:last_build_status) { 'success' }
  let(:last_build_time) { '2016-01-15T17:42:34.000+08:00' }
  let(:last_committer) { 'Luke Skywalker' }

  let!(:repo_request) do
  end
  let!(:build_response_body) do
    {"build" => { "state" => last_build_status,
                  "finished_at" => '2016-01-15T09:42:34Z' },
                  "commit" => { "author_name" => last_committer }}.to_json
  end
  let!(:build_request) do
  end

  before do
    d = Dashboard.create(title: 'Default Dashboard')
    w = Widget.create(title: 'Title', dashboard: d, category: 'ci_widget')
    w.update(opts)

    stub_request(:get, "#{server_url}/repos/#{project_name}")
      .with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json', 'Authorization' => 'Token "' + auth_key + '"' })
      .to_return(body: {"repo" => {"last_build_id" => build_id}}.to_json, headers: {'Content-Type' => 'application/json'})

    stub_request(:get, "#{server_url}/repos/#{project_name}/builds/#{build_id}")
      .with(headers: {'Accept' => 'application/vnd.travis-ci.2+json', 'Authorization' => 'Token "' + auth_key + '"' })
      .to_return(body: build_response_body, headers: {'Content-Type' => 'application/json'})
  end

  it "must create a widget", js: true do
    visit '/'
    expect(page).to have_content project_name
    expect(page).to have_content last_build_status
    expect(page).to have_content last_build_time
    expect(page).to have_content last_committer
  end

  it "must update its status", js: true, slow: true do
    visit '/'
    expect(page).to have_content last_build_status

    #changing the stub to simulate a change in the repository status
    new_build_details = {
      "build" => { "state" => 'failed',
                   "finished_at" => '2016-01-15T09:42:34Z' },
                   "commit" => { "author_name" => 'Ray' }
    }.to_json

    stub_request(:get, "#{server_url}/repos/#{project_name}/builds/#{build_id}")
      .with(headers: {'Accept' => 'application/vnd.travis-ci.2+json', 'Authorization' => 'Token "' + auth_key + '"' })
      .to_return(body: new_build_details, headers: {'Content-Type' => 'application/json'})

    expect(page).to have_content 'failed', wait: 35
    expect(page).to have_content 'Ray'

  end
end
