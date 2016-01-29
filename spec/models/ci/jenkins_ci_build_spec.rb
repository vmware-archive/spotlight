require 'rails_helper'

RSpec.describe Ci::JenkinsCiBuild do
  describe '#initialize' do
    let(:state) { 'SUCCESS' }
    let(:timestamp) { '2016-01-27T16:35:48+08:00' }
    let(:author_name) { 'Rahul Rajeev' }

    let(:build_info) do
      {
          "number" => 716,
          "result" => state,
          "timestamp" => 1453883748620,
          "changeSet" => { "items" => [ {"author"=>{'fullName'=>author_name}} ]}
      }
    end

    subject { Ci::JenkinsCiBuild.new(build_info) }

    it 'initializes' do
      expect(subject.state).to eq Category::CiWidget::STATUS_PASSED
      expect(subject.timestamp).to eq timestamp
      expect(subject.committer).to eq author_name
    end
  end
end