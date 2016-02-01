require 'rails_helper'

RSpec.describe Ci::TravisCiService do
  describe '#initialize' do
    let(:state) { 'started' }
    let(:start_timestamp) { '2016-01-29T09:43:34Z' }
    let(:stop_timestamp) { '2016-01-29T09:47:24Z' }
    let(:author_name) { "Rahul Rajeev" }
    let(:build_info) do
      {
          'build' => { "state" => state, 'started_at' => start_timestamp, 'finished_at' => stop_timestamp },
          'commit' => {
              "id" => 28475154,
              "sha" => "ff8065933ddebc03ddce7e5971a3331055fe08d9",
              "branch" => "master",
              "message" => "Update payload to return an array of objects instead of just string.\n\n[#111938377]",
              "committed_at" => "2016-01-28T09:57:02Z",
              "author_name" => author_name,
              "author_email" => "sg+mcn@neo.com",
              "committer_name" => "Michael Cheng",
              "committer_email" => "sg+mcn@neo.com",
              "compare_url" => "https://github.com/neo/spotlight/compare/bbb3ec6e6048...ff8065933dde",
              "pull_request_number" => nil
          }
      }
    end

    subject { Ci::TravisCiBuild.new(build_info) }

    it 'initializes state and committer' do
      expect(subject.state).to eq Category::CiWidget::STATUS_BUILDING
      expect(subject.committer).to eq author_name
    end

    context 'started build' do
      let(:state) { 'started' }

      it 'uses the `started_at` timestamp' do
        expect(subject.timestamp).to eq start_timestamp
      end
    end

    %w(passed failed).each do |state|
      context "#{state}{ build" do
        let(:state) { state }

        it 'uses the `finished_at` timestamp' do
          expect(subject.timestamp).to eq(stop_timestamp)
        end
      end
    end
  end
end