require 'rails_helper'

RSpec.describe Ci::CircleCiBuild do
  describe '#initialize' do
    let(:state) { 'running' }
    let(:start_timestamp) { '2016-01-15T08:00:20.000Z' }
    let(:stop_timestamp) { '2016-01-15T08:20:20.000Z' }
    let(:author_name) { "Rahul Rajeev" }

    let(:build_info) do
      {
        'status' => state,
        'committer_name' => author_name,
        'outcome' => state,
        'stop_time' => stop_timestamp,
        'start_time' => start_timestamp,
        'usage_queued_at' => '2016-01-15T08:20:00.000Z'
      }
    end

    subject { Ci::CircleCiBuild.new(build_info) }

    it 'initializes state and committer' do
      expect(subject.state).to eq Category::CiWidget::STATUS_BUILDING
      expect(subject.committer).to eq author_name
    end

    context 'started build' do
      let(:state) { 'running' }

      it 'uses the `start_time` timestamp' do
        expect(subject.timestamp).to eq start_timestamp
      end
    end

    %w(success failed fixed cancelled).each do |state|
      context "when the state it #{state}" do
        let(:state) { state }

        it 'uses the `stop_time` timestamp' do
          expect(subject.timestamp).to eq(stop_timestamp)
        end
      end
    end
  end
end