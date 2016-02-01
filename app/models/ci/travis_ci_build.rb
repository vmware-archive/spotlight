module Ci
  class TravisCiBuild < BaseBuild
    STATUSES = {
        'passed' => Category::CiWidget::STATUS_PASSED,
        'failed' => Category::CiWidget::STATUS_FAILED,
        'started' => Category::CiWidget::STATUS_BUILDING
    }

    def initialize(build_info={})
      build = build_info['build']

      @state = self.class.normalized_state_for(build['state'])

      relevant_timestamp = @state == Category::CiWidget::STATUS_BUILDING ? build['started_at'] : build['finished_at']
      @timestamp         = self.class.parse_timestamp(relevant_timestamp)

      @committer = build_info.dig('commit', 'author_name') || ''
    end

    def self.parse_timestamp(timestamp_string)
      Time.parse(timestamp_string).localtime.to_datetime
    end
  end
end