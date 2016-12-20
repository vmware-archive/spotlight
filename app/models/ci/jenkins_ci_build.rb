module Ci
  class JenkinsCiBuild < BaseBuild
    STATUSES = {
        'SUCCESS' => Category::CiWidget::STATUS_PASSED,
        'FAILURE' => Category::CiWidget::STATUS_FAILED,
        'ABORTED' => Category::CiWidget::STATUS_FAILED,
        nil => Category::CiWidget::STATUS_BUILDING # Jenkins returns null when its building
    }

    def initialize(build={})
      if build['building']
        @state = Category::CiWidget::STATUS_BUILDING
      else
        @state = self.class.normalized_state_for(build['result'])
      end

      @timestamp = self.class.parse_timestamp(build['timestamp'])

      if build['changeSet'].present?
        commit = build['changeSet']['items']
      elsif build['changeSets'].present?
        commit = build['changeSets'][0]['items']
      end

      @committer = commit.dig(0, 'author', 'fullName') || ''
    end

    def self.parse_timestamp(timestamp_string)
      Time.at(timestamp_string / 1000).to_datetime
    end
  end
end
