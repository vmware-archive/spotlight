class Category < ClassyEnum::Base
  def fields
    {}
  end
end

class Category::ClockWidget < Category
end

class Category::CiWidget < Category
  STATUS_PASSED = 'passed'
  STATUS_FAILED = 'failed'
  STATUS_BUILDING = 'building'
  STATUS_UNKNOWN = 'unknown'

  STATUSES = [
    STATUS_PASSED, STATUS_FAILED, STATUS_BUILDING, STATUS_UNKNOWN
  ]

  def fields
    {
      server_type: [:travis_ci, :jenkins_ci, :circle_ci],
      server_url: nil,
      project_name: nil,
      auth_key: nil
    }
  end
end
