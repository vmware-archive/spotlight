require 'rails_helper'

RSpec.describe Ci::CircleCiBuild do
  describe '#initialize' do
    let(:state) { 'running' }
    let(:timestamp) { '2016-01-15T08:00:20.000Z' }
    let(:author_name) { "Rahul Rajeev" }

    let(:build_info) do
      {
        'status' => state,
        'committer_name' => author_name,
        'outcome' => state,
        'stop_time' => nil,
        'start_time' => timestamp,
        'usage_queued_at' => '2016-01-15T08:20:00.000Z'
      }
    end

    subject { Ci::CircleCiBuild.new(build_info) }

    it 'initializes' do
      expect(subject.state).to eq Category::CiWidget::STATUS_BUILDING
      expect(subject.timestamp).to eq timestamp
      expect(subject.committer).to eq author_name
    end
  end
end