require 'rails_helper'

RSpec.describe JenkinsCiService do
  let(:basic_auth) { 'user:password' }
  let(:server_url) { "http://#{basic_auth}@portsdown.local:8080" }
  let(:auth_key) { Base64.encode64(basic_auth) }
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
          with(headers: { 'Accept' => 'application/json'}).
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
          with(headers: { 'Accept' => 'application/json'}).
          to_return(body:    '{"foo":"bar"}',
                    headers: {'Content-Type' => 'application/json'})

      result = subject.build_info(build_id)

      expect(mock_request).to have_been_made
      expect(result["foo"]).to eq "bar"
    end
  end

  let(:build_history_response_body) do
    { "builds" => [
        { "number" => 716, 'building' => false, "result" => "SUCCESS", "timestamp" => 1453883748620, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'Rahul Rajeev'}} ]} },
        { "number" => 715, 'building' => false, "result" => "FAILURE", "timestamp" => 1453796262456, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} },
        { "number" => 714, 'building' => false, "result" => "SUCCESS", "timestamp" => 1453794808186, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} },
        { "number" => 713, 'building' => false, "result" => "SUCCESS", "timestamp" => 1453792548935, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} },
        { "number" => 712, 'building' => false, "result" => "FAILURE", "timestamp" => 1453782648654, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} },
        { "number" => 711, 'building' => false, "result" => "SUCCESS", "timestamp" => 1453777248465, "changeSet" => {"items" => [ {"author"=>{'fullName'=>'benjamintanweihao'}} ]} }
      ]
    }.to_json
  end

  describe '#build_history' do
    it 'returns build history' do

      builds_request = stub_request(:get, "#{server_url}/job/#{project_name}/api/json?tree=builds[number,building,timestamp,result,committer_name,changeSet[items[author[fullName]]],changeSets[items[author[fullName]]]]").
          with(headers: { 'Accept' => 'application/json'}).
          to_return(body: build_history_response_body,
                    headers: {'Content-Type' => 'application/json'})

      result = subject.build_history

      expect(builds_request).to have_been_made
      expect(result.count).to eq 5
    end
  end
end
