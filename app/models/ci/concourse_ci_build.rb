module Ci
  class ConcourseCiBuild < BaseBuild
    STATUSES = {
      'succeeded' => Category::CiWidget::STATUS_PASSED,
      'failed' => Category::CiWidget::STATUS_FAILED
    }

    def initialize build_info = {}
      @state = self.class.normalized_state_for build_info[:status]
      @timestamp = build_info[:end]
      @committer = 'N/A'
    end
  end
end
