require 'rails_helper'

describe "travis widget spec", :type => :feature do
  let(:server_url) { 'https://api.travis-ci.com' }
  let(:auth_key) { 'auth_key' }
  let(:project_name) { 'the_resistance/x_wing' }

  let(:build_id) { 12345 }
  let(:last_build_status) { 'failed' }
  let(:last_build_time) { '2016-01-28T09:03:32Z' }
  let(:last_committer) { 'Luke Skywalker' }

  let!(:build_history_response) do
    {
        "builds" => [
            { "state" => last_build_status, started_at: '2016-01-28T09:02:32Z', finished_at: last_build_time },
            { "state" => 'passed', started_at: '2016-01-28T08:18:46Z', finished_at: '2016-01-28T08:21:47Z' },
            { "state" => 'failed', started_at: '2016-01-28T06:43:57Z', finished_at: '2016-01-28T06:47:48Z' },
            { "state" => 'failed', started_at: '2016-01-28T04:09:34Z', finished_at: '2016-01-28T04:12:34Z' },
            { "state" => 'failed', started_at: '2016-01-27T09:10:35Z', finished_at: '2016-01-27T09:13:23Z' },
            { "state" => 'passed', started_at: '2016-01-27T08:11:46Z', finished_at: '2016-01-27T08:14:49Z' }
        ],
        "commits" => [
            {
                "id" => 28475154,
                "sha" => "ff8065933ddebc03ddce7e5971a3331055fe08d9",
                "branch" => "master",
                "message" => "Update payload to return an array of objects instead of just string.\n\n[#111938377]",
                "committed_at" => "2016-01-28T09:57:02Z",
                "author_name" => last_committer,
                "author_email" => "sg+mcn@neo.com",
                "committer_name" => "Michael Cheng",
                "committer_email" => "sg+mcn@neo.com",
                "compare_url" => "https://github.com/neo/spotlight/compare/bbb3ec6e6048...ff8065933dde",
                "pull_request_number" => nil
            },
            {
                "id" => 28472170,
                "sha" => "bbb3ec6e6048dc5aacc08809ad152275dfa1f607",
                "branch" => "master",
                "message" => "Remove the server side reversal of the order of Build History.\n\n[#111938377]",
                "committed_at" => "2016-01-28T08:52:32Z",
                "author_name" => "Michael Cheng",
                "author_email" => "sg+mcn@neo.com",
                "committer_name" => "Michael Cheng",
                "committer_email" => "sg+mcn@neo.com",
                "compare_url" => "https://github.com/neo/spotlight/compare/945a29cbef27...bbb3ec6e6048",
                "pull_request_number" => nil
            },
            {
                "id" => 28470139,
                "sha" => "945a29cbef27cd287a5b1e87aea96b95ce91728e",
                "branch" => "master",
                "message" => "Normalised build statuses.\n\n[#111938377]",
                "committed_at" => "2016-01-28T08:18:00Z",
                "author_name" => "Michael Cheng",
                "author_email" => "sg+mcn@neo.com",
                "committer_name" => "Michael Cheng",
                "committer_email" => "sg+mcn@neo.com",
                "compare_url" => "https://github.com/neo/spotlight/compare/acc58dbe4b2e...945a29cbef27",
                "pull_request_number" => nil
            },
            {
                "id" => 28466719,
                "sha" => "acc58dbe4b2e4af5f1ffbdf19573ddd3bca721a3",
                "branch" => "master",
                "message" => "Show last 5 history.\n\n- Fix feature test.\n\n[#111938377]",
                "committed_at" => "2016-01-28T06:43:07Z",
                "author_name" => "Michael Cheng",
                "author_email" => "sg+mcn@neo.com",
                "committer_name" => "Michael Cheng",
                "committer_email" => "sg+mcn@neo.com",
                "compare_url" => "https://github.com/neo/spotlight/compare/a1ccf5530da0...acc58dbe4b2e",
                "pull_request_number" => nil
            },
            {
                "id" => 28462052,
                "sha" => "a1ccf5530da038e1db1e8884fc0d8a2c19e4355b",
                "branch" => "master",
                "message" => "Current dashboard layout is stored as a state\n\n[no-pt-story]",
                "committed_at" => "2016-01-28T04:09:11Z",
                "author_name" => "Rahul Rajeev",
                "author_email" => "rahul@neo.com",
                "committer_name" => "Rahul Rajeev",
                "committer_email" => "rahul@neo.com",
                "compare_url" => "https://github.com/neo/spotlight/compare/a779f9ccbf7d...a1ccf5530da0",
                "pull_request_number" => nil
            }
        ]
    }.to_json
  end

  before do
    d = FactoryGirl.create :dashboard, title: 'Default Dashboard'
    w = FactoryGirl.create :widget, title: 'spotlight', dashboard: d, server_url: server_url, auth_key: auth_key, project_name: project_name, server_type: 'travis_ci'

    stub_request(:get, "#{server_url}/repos/#{project_name}/builds").
      with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                      'Authorization' => 'Token "' + auth_key + '"' }).
      to_return(body: build_history_response,
                headers: {'Content-Type' => 'application/json'})
  end

  it "must create a widget", js: true do
    visit '/'
    expect(page.find(('.inner-ci-widget.' + Category::CiWidget::STATUS_FAILED) , wait: 10)).to be
    expect(page).to have_content last_committer
    expect(page).to have_content 'spotlight'
  end

  it "must update its status", js: true, slow: true do
    visit '/'

    expect(page).to have_content last_committer

    #changing the stub to simulate a change in the repository status
    build_history_response = {
      "builds" => [
          { "state" => 'passed', started_at: '2016-01-27T09:10:35Z', finished_at: '2016-01-27T09:13:23Z' }
      ],
      "commits" => [
          { "author_name" => "Ray" }
      ]
    }.to_json

    stub_request(:get, "#{server_url}/repos/#{project_name}/builds").
        with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                        'Authorization' => 'Token "' + auth_key + '"' }).
        to_return(body: build_history_response,
                  headers: {'Content-Type' => 'application/json'})

    expect(page.find('.inner-ci-widget.passed', wait: 45)).to be
    expect(page).to_not have_content 'Ray'

  end
end
