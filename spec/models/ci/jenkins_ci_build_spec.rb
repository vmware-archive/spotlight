require 'rails_helper'

RSpec.describe Ci::JenkinsCiBuild do
  describe '#initialize' do
    let(:state) { 'SUCCESS' }
    let(:timestamp) { '2016-01-27T16:35:48+08:00' }
    let(:author_name) { 'Rahul Rajeev' }
    let(:items) { [ {"author"=>{'fullName'=>author_name}} ] }

    let(:build_info) do
      {
          "number" => 716,
          "result" => state,
          "timestamp" => 1453883748620,
          "changeSet" => { "items" => items}
      }
    end

    subject { Ci::JenkinsCiBuild.new(build_info) }

    it 'initializes state, committer and timestamp' do
      expect(subject.state).to eq Category::CiWidget::STATUS_PASSED
      expect(subject.committer).to eq author_name
      expect(subject.timestamp).to eq timestamp
    end

    describe 'changeset item is not present' do
      let(:items) { [] }
      it 'initializes author_name to blank' do
        expect(subject.committer).to eq ''
      end
    end
  end
end