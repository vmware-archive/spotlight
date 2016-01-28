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
      expect(result.body["foo"]).to eq "bar"
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
      expect(result.body["foo"]).to eq "bar"
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
    let!(:builds_response_body) do
      {"builds" => [
          { "state" => 'started' },
          { "state" => 'passed' },
          { "state" => 'failed' },
          { "state" => 'failed' },
          { "state" => 'failed' },
          { "state" => 'passed' }
        ]
      }.to_json
    end
    let!(:builds_request) do
      stub_request(:get, "#{server_url}/repos/#{project_name}/builds").
        with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                        'Authorization' => 'Token "' + auth_key + '"' }).
        to_return(body: builds_response_body,
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
      expect(result[:build_history]).to eq [ Category::CiWidget::STATUS_BUILDING,
                                             Category::CiWidget::STATUS_PASSED,
                                             Category::CiWidget::STATUS_FAILED,
                                             Category::CiWidget::STATUS_FAILED,
                                             Category::CiWidget::STATUS_FAILED ]
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

  describe '#build_history' do
    let!(:builds_response_body) do
      {"builds" => [
          { "state" => 'started' },
          { "state" => 'passed' },
          { "state" => 'failed' },
          { "state" => 'failed' },
          { "state" => 'failed' },
          { "state" => 'passed' }
        ]
      }.to_json
    end
    let!(:builds_request) do
      stub_request(:get, "#{server_url}/repos/#{project_name}/builds").
        with(headers: { 'Accept' => 'application/vnd.travis-ci.2+json',
                        'Authorization' => 'Token "' + auth_key + '"' }).
        to_return(body: builds_response_body,
                  headers: {'Content-Type' => 'application/json'})
    end

    it 'fetches build history' do
      result = subject.build_history

      expect(result.count).to eq 5
    end
  end
end
