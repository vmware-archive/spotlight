module Ci
  class CircleCiBuild < BaseBuild
    STATUSES = {
        'success' => Category::CiWidget::STATUS_PASSED,
        'fixed' => Category::CiWidget::STATUS_PASSED,
        'failed' => Category::CiWidget::STATUS_FAILED,
        'canceled' => Category::CiWidget::STATUS_FAILED,
        'running' => Category::CiWidget::STATUS_BUILDING
    }

    def initialize(build={})
      @state = self.class.normalized_state_for(build['status'])

      relevant_timestamp = @state == Category::CiWidget::STATUS_BUILDING ? build['start_time'] : build['stop_time']
      @timestamp         = self.class.parse_timestamp(relevant_timestamp)

      @committer = build['committer_name']
    end

    def self.parse_timestamp(timestamp_string)
      return '' if timestamp_string.nil?
      Time.parse(timestamp_string).localtime.to_datetime
    end
  end
end
