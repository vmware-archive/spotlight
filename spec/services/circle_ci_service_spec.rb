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
end
