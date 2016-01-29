require 'rails_helper'

RSpec.describe JenkinsCiService do
  let(:server_url) { 'http://portsdown.local:8080' }
  let(:auth_key) { 'auth_key' }
  let(:project_name) { 'Concierge' }
  let(:opts) do
    {
      server_url: server_url,
      auth_key: auth_key,
      project_name: project_name
    }
  end

  subject{ JenkinsCiService.new(opts) }

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
                  server_type: 'jenkins_ci',
                  server_url: server_url,
                  auth_key: auth_key,
                  project_name: project_name
    }

    subject{ JenkinsCiService.for_widget(widget) }

    it 'sets default values' do
      expect(subject.server_url).to eq server_url
      expect(subject.auth_key).to eq auth_key
      expect(subject.project_name).to eq project_name
    end
  end

  describe '#repo_info' do
    it 'makes request to repo' do
      mock_request = stub_request(:get, "#{server_url}/job/#{project_name}/api/json").
          with(headers: { 'Accept' => 'application/json',
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
      mock_request = stub_request(:get, "#{server_url}/job/#{project_name}/#{build_id}/api/json").
          with(headers: { 'Accept' => 'application/json',
                          'Authorization' => 'Token "' + auth_key + '"' }).
          to_return(body:    '{"foo":"bar"}',
                    headers: {'Content-Type' => 'application/json'})

      result = subject.build_info(build_id)

      expect(mock_request).to have_been_made
      expect(result["foo"]).to eq "bar"
    end
  end

  let(:build_history_response_body) do
    { "builds" => [
        { "number" => 716, "result" => "SUCCESS", "timestamp" => 1453883748620, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'Rahul Rajeev'}} ]} },
        { "number" => 715, "result" => "FAILURE", "timestamp" => 1453796262456, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} },
        { "number" => 714, "result" => "SUCCESS", "timestamp" => 1453794808186, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} },
        { "number" => 713, "result" => "SUCCESS", "timestamp" => 1453792548935, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} },
        { "number" => 712, "result" => "FAILURE", "timestamp" => 1453782648654, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} },
        { "number" => 711, "result" => "SUCCESS", "timestamp" => 1453777248465, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} }
      ]
    }.to_json
  end

  describe '#build_history' do
    it 'returns build history' do

      builds_request = stub_request(:get, "#{server_url}/job/#{project_name}/api/json?tree=builds[number,timestamp,result,committer_name,changeSet[items[author[fullName]]]]").
          with(headers: { 'Accept' => 'application/json',
                          'Authorization' => 'Token "' + auth_key + '"' }).
          to_return(body: build_history_response_body,
                    headers: {'Content-Type' => 'application/json'})

      result = subject.build_history

      expect(builds_request).to have_been_made
      expect(result.count).to eq 5
    end
  end

  describe '#last_build_info' do
    let(:build_id) { 12345 }
    let(:is_building) { false }
    let(:last_build_status) { 'SUCCESS' }
    let(:last_build_time) { '2016-01-27T16:35:48+08:00' }
    let(:last_committer) { 'Rahul Rajeev' }

    it 'makes request to repo' do
      builds_history_request = stub_request(:get, "#{server_url}/job/#{project_name}/api/json?tree=builds[number,timestamp,result,committer_name,changeSet[items[author[fullName]]]]").
          with(headers: { 'Accept' => 'application/json',
                          'Authorization' => 'Token "' + auth_key + '"' }).
          to_return(body: build_history_response_body,
                    headers: {'Content-Type' => 'application/json'})

      result = subject.last_build_info

      expect(builds_history_request).to have_been_made
      expect(result.keys).to include :repo_name, :last_build_status, :last_committer, :last_build_time
      expect(result[:repo_name]).to eq project_name
      expect(result[:last_build_time]).to eq last_build_time
      expect(result[:last_build_status]).to eq Category::CiWidget::STATUS_PASSED
      expect(result[:last_committer]).to eq last_committer
      expect(result[:build_history]).to eq [
                                             { state: Category::CiWidget::STATUS_PASSED, committer: last_committer, timestamp: last_build_time },
                                             { state: Category::CiWidget::STATUS_FAILED, committer: 'benjamintanweihao', timestamp: '2016-01-26T16:17:42+08:00' },
                                             { state: Category::CiWidget::STATUS_PASSED, committer: 'benjamintanweihao', timestamp: '2016-01-26T15:53:28+08:00' },
                                             { state: Category::CiWidget::STATUS_PASSED, committer: 'benjamintanweihao', timestamp: '2016-01-26T15:15:48+08:00' },
                                             { state: Category::CiWidget::STATUS_FAILED, committer: 'benjamintanweihao', timestamp: '2016-01-26T12:30:48+08:00' }
      ]
    end
  end
end
