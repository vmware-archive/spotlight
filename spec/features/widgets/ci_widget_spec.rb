require 'rails_helper'

describe "travis widget spec", :type => :feature do
  let(:server_url) { 'https://api.travis-ci.com' }
  let(:auth_key) { 'auth_key' }
  let(:project_name) { 'the_resistance/x_wing' }

  let(:build_id) { 12345 }
  let(:last_build_status) { 'passed' }
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
  let!(:builds_response_body) do
    {"builds" => [
        { "state" => 'started', started_at: '2016-01-28T09:03:32Z' },
        { "state" => 'passed', started_at: '2016-01-28T08:18:46Z', finished_at: '2016-01-28T08:21:47Z' },
        { "state" => 'failed', started_at: '2016-01-28T06:43:57Z', finished_at: '2016-01-28T06:47:48Z' },
        { "state" => 'failed', started_at: '2016-01-28T04:09:34Z', finished_at: '2016-01-28T04:12:34Z' },
        { "state" => 'failed', started_at: '2016-01-27T09:10:35Z', finished_at: '2016-01-27T09:13:23Z' },
        { "state" => 'passed', started_at: '2016-01-27T08:11:46Z', finished_at: '2016-01-27T08:14:49Z' }
      ]
    }.to_json
  end

  before do
    d = FactoryGirl.create :dashboard, title: 'Default Dashboard'
    w = FactoryGirl.create :widget, dashboard: d, server_url: server_url, auth_key: auth_key, project_name: project_name, server_type: 'travis_ci'

    stub_request(:get, "#{server_url}/repos/#{project_name}")
      .with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json', 'Authorization' => 'Token "' + auth_key + '"' })
      .to_return(body: {"repo" => {"last_build_id" => build_id}}.to_json, headers: {'Content-Type' => 'application/json'})

    stub_request(:get, "#{server_url}/repos/#{project_name}/builds/#{build_id}")
      .with(headers: {'Accept' => 'application/vnd.travis-ci.2+json', 'Authorization' => 'Token "' + auth_key + '"' })
      .to_return(body: build_response_body, headers: {'Content-Type' => 'application/json'})

    stub_request(:get, "#{server_url}/repos/#{project_name}/builds").
      with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                      'Authorization' => 'Token "' + auth_key + '"' }).
      to_return(body: builds_response_body,
                headers: {'Content-Type' => 'application/json'})
  end

  it "must create a widget", js: true do
    visit '/'
    expect(page).to have_content project_name, wait: 10
    expect(page).to have_content last_build_status
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

    expect(page).to have_content 'failed', wait: 60
    expect(page).to have_content 'Ray'

  end
end
