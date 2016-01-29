require 'rails_helper'

RSpec.describe TravisCiService do
  let(:server_url) { 'https://api.travis-ci.com' }
  let(:auth_key) { 'auth_key' }
  let(:project_name) { 'neo/spotlight' }
  let(:opts) do
    {
      server_url: server_url,
      auth_key: auth_key,
      project_name: project_name
    }
  end

  subject{ TravisCiService.new(opts) }

  describe '#initialize' do
    it 'sets default values' do
      expect(subject.server_url).to eq server_url
      expect(subject.auth_key).to eq auth_key
      expect(subject.project_name).to eq project_name
    end
  end

  describe '.for_widget' do
    let(:dashboard) { FactoryGirl.create :dashboard }
    let(:widget){
      FactoryGirl.create :widget,
                  dashboard: dashboard,
                  category: 'ci_widget',
                  server_type: 'travis_ci',
                  server_url: server_url,
                  auth_key: auth_key,
                  project_name: project_name
    }

    subject{ TravisCiService.for_widget(widget) }

    it 'sets default values' do
      expect(subject.server_url).to eq server_url
      expect(subject.auth_key).to eq auth_key
      expect(subject.project_name).to eq project_name
    end
  end

  describe '#repo_info' do
    it 'makes request to repo' do
      mock_request = stub_request(:get, "#{server_url}/repos/#{project_name}").
          with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                          'Authorization' => 'Token "' + auth_key + '"' }).
          to_return(body:    '{"foo":"bar"}',
                    headers: {'Content-Type' => 'application/json'})

      result = subject.repo_info

      expect(mock_request).to have_been_made
      expect(result["foo"]).to eq "bar"
    end
  end

  describe '#build_info' do
    let(:build_id) { 12345 }

    it 'makes request to repo' do
      mock_request = stub_request(:get, "#{server_url}/repos/#{project_name}/builds/#{build_id}").
          with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                          'Authorization' => 'Token "' + auth_key + '"' }).
          to_return(body:    '{"foo":"bar"}',
                    headers: {'Content-Type' => 'application/json'})

      result = subject.build_info(build_id)

      expect(mock_request).to have_been_made
      expect(result["foo"]).to eq "bar"
    end
  end

  let!(:build_history_response) do
    {
        "builds" => [
            { "state" => 'started', started_at: '2016-01-28T09:03:32Z' },
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
                "author_name" => "Rahul Rajeev",
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

  describe '#build_history' do
    let!(:builds_request) do
      stub_request(:get, "#{server_url}/repos/#{project_name}/builds").
        with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                        'Authorization' => 'Token "' + auth_key + '"' }).
        to_return(body: build_history_response,
                  headers: {'Content-Type' => 'application/json'})
    end

    it 'fetches build history' do
      result = subject.build_history

      expect(result.count).to eq 5
      expect(result.first.keys).to eq %w(build commit)
    end
  end

  describe '#last_build_info' do
    let(:build_id) { 12345 }
    let(:last_build_status) { 'passed' }
    let(:last_build_time) { '2016-01-15T17:42:34.000+08:00' }
    let(:last_committer) { 'Rahul Rajeev' }

    let!(:repo_request) do
      stub_request(:get, "#{server_url}/repos/#{project_name}").
        with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                        'Authorization' => 'Token "' + auth_key + '"' }).
        to_return(body: {"repo" => {"last_build_id" => build_id}}.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end
    let!(:build_response_body) do
      {"build" => { "state" => last_build_status,
                    "finished_at" => '2016-01-15T09:42:34Z' },
       "commit" => { "author_name" => last_committer }}.to_json
    end
    let!(:build_request) do
      stub_request(:get, "#{server_url}/repos/#{project_name}/builds/#{build_id}").
        with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                        'Authorization' => 'Token "' + auth_key + '"' }).
        to_return(body: build_response_body,
                  headers: {'Content-Type' => 'application/json'})
    end
    let!(:builds_request) do
      stub_request(:get, "#{server_url}/repos/#{project_name}/builds").
        with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                        'Authorization' => 'Token "' + auth_key + '"' }).
        to_return(body: build_history_response,
                  headers: {'Content-Type' => 'application/json'})
    end

    it 'makes request to repo' do
      result = subject.last_build_info

      expect(repo_request).to have_been_made
      expect(build_request).to have_been_made
      expect(result.keys).to include :repo_name, :last_build_status, :last_committer, :last_build_time
      expect(result[:repo_name]).to eq project_name
      expect(result[:last_build_time]).to eq last_build_time
      expect(result[:last_build_status]).to eq Category::CiWidget::STATUS_PASSED
      expect(result[:last_committer]).to eq last_committer
      expect(result[:build_history]).to eq [
        { state: Category::CiWidget::STATUS_BUILDING, committer: last_committer, timestamp: '2016-01-28T09:03:32Z' },
        { state: Category::CiWidget::STATUS_PASSED, committer: 'Michael Cheng', timestamp: '2016-01-28T08:21:47Z' },
        { state: Category::CiWidget::STATUS_FAILED, committer: 'Michael Cheng', timestamp: '2016-01-28T06:47:48Z' },
        { state: Category::CiWidget::STATUS_FAILED, committer: 'Michael Cheng', timestamp: '2016-01-28T04:12:34Z' },
        { state: Category::CiWidget::STATUS_FAILED, committer: 'Rahul Rajeev', timestamp: '2016-01-27T09:13:23Z' },
      ]
    end

    context 'build just started' do
      let!(:build_response_body) do
        {"build" => { "state" => last_build_status,
                      "started_at" => '2016-01-15T09:42:34Z',
                      "finished_at" => nil },
         "commit" => { "author_name" => last_committer }}.to_json
      end

      it 'displays the started_at timing' do
        result = subject.last_build_info

        expect(result[:last_build_time]).to eq last_build_time
      end
    end
  end
end
