module Ci
  class ConcourseCiBuild < BaseBuild
    STATUSES = {
      'succeeded' => Category::CiWidget::STATUS_PASSED,
      'failed' => Category::CiWidget::STATUS_FAILED,
      'started' => Category::CiWidget::STATUS_BUILDING
    }

    def initialize(build_info = {})
      @state = self.class.normalized_state_for build_info[:status]
      @timestamp = @state == Category::CiWidget::STATUS_BUILDING ? build_info[:start] : build_info[:end]
      @committer = 'N/A'
    end
  end
end
