require 'rails_helper'

RSpec.describe CircleCiService do
  let(:server_url) { 'https://circleci.com' }
  let(:auth_key) { 'auth_key' }
  let(:project_name) { 'samsung-repo/Chinchilla' }
  let(:opts) do
    {
      server_url: server_url,
      auth_key: auth_key,
      project_name: project_name
    }
  end

  subject{ CircleCiService.new(opts) }

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
                  server_type: 'circle_ci',
                  server_url: server_url,
                  auth_key: auth_key,
                  project_name: project_name
    }

    subject{ CircleCiService.for_widget(widget) }

    it 'sets default values' do
      expect(subject.server_url).to eq server_url
      expect(subject.auth_key).to eq auth_key
      expect(subject.project_name).to eq project_name
    end
  end

  describe '#repo_info' do
    it 'makes request to repo' do
      mock_request = stub_request(:get, "#{server_url}/api/v1/project/#{project_name}?circle-token=#{auth_key}").
          with(headers: { 'Accept' => 'application/json' }).
          to_return(body:    '[{"foo":"bar"}]',
                    headers: {'Content-Type' => 'application/json'})

      result = subject.repo_info

      expect(mock_request).to have_been_made
      expect(result[0]["foo"]).to eq "bar"
    end
  end

  describe '#build_info' do
    let(:build_id) { 12345 }

    it 'makes request to repo' do
      mock_request = stub_request(:get, "#{server_url}/api/v1/project/#{project_name}/#{build_id}?circle-token=#{auth_key}").
          with(headers: { 'Accept' => 'application/json' }).
          to_return(body:    '{"foo":"bar"}',
                    headers: {'Content-Type' => 'application/json'})

      result = subject.build_info(build_id)

      expect(mock_request).to have_been_made
      expect(result["foo"]).to eq "bar"
    end
  end

  describe '#build_history' do
    it 'returns build history' do
      mock_request = stub_request(:get, "#{server_url}/api/v1/project/#{project_name}?circle-token=#{auth_key}").
          with(headers: { 'Accept' => 'application/json' }).
          to_return(body:    '[{"status":"failed"}, {"status":"success"}, {"status":"cancelled"}, {"status":"fixed"}, {"status":"success"}]',
                    headers: {'Content-Type' => 'application/json'})

      result = subject.build_history

      expect(mock_request).to have_been_made
      expect(result.count).to eq 5
    end
  end

  describe '#last_build_info' do
    let(:build_id) { 12345 }
    let(:last_build_status) { 'running' }
    let(:last_build_time) { '2016-01-15T08:00:20.000Z' }
    let(:last_committer) { 'Rahul Rajeev' }

    it 'makes request to repo' do
      build_response_body = [
        {
          status: last_build_status,
          committer_name: last_committer,
          outcome: last_build_status,
          stop_time: '2016-01-15T08:20:20.000Z',
          start_time: '2016-01-15T08:00:20.000Z',
          usage_queued_at: '2016-01-15T08:20:00.000Z'
        },
        { status: 'success', stop_time: '2016-01-28T07:46:14.681Z', committer_name: 'Yifeng Hou'},
        { status: 'cancelled', stop_time: '2015-10-09T10:28:42.832Z', committer_name: 'Michael Cheng' },
        { status: 'fixed', stop_time: '2015-10-09T10:25:25.476Z', committer_name: 'Yifeng Hou' },
        { status: 'failed', stop_time: '2015-10-09T05:13:12.398Z', committer_name: 'Yifeng Hou' },
      ].to_json

      build_request = stub_request(:get, "#{server_url}/api/v1/project/#{project_name}?circle-token=#{auth_key}").
          with(headers: { 'Accept' => 'application/json' }).
          to_return(body: build_response_body,
                    headers: {'Content-Type' => 'application/json'})

      result = subject.last_build_info

      expect(build_request).to have_been_made
      expect(result.keys).to include :repo_name, :build_history
      expect(result[:repo_name]).to eq project_name
      expect(result[:build_history]).to eq [
                                             { state: Category::CiWidget::STATUS_BUILDING, committer: last_committer, timestamp: '2016-01-15T08:00:20.000Z' },
                                             { state: Category::CiWidget::STATUS_PASSED, committer: 'Yifeng Hou', timestamp: '2016-01-28T07:46:14.681Z' },
                                             { state: Category::CiWidget::STATUS_FAILED, committer: 'Michael Cheng', timestamp: '2015-10-09T10:28:42.832Z' },
                                             { state: Category::CiWidget::STATUS_PASSED, committer: 'Yifeng Hou', timestamp: '2015-10-09T10:25:25.476Z' },
                                             { state: Category::CiWidget::STATUS_FAILED, committer: 'Yifeng Hou', timestamp: '2015-10-09T05:13:12.398Z' }
      ]
    end
  end
end
