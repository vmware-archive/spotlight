module Ci
  class BaseBuild
    attr_reader :committer, :state, :timestamp

    def self.normalized_state_for(state)
      self::STATUSES[state] || Category::CiWidget::STATUS_UNKNOWN
    end
  end
end