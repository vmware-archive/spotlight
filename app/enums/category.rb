class Category < ClassyEnum::Base
  def fields
    {}
  end
end

class Category::ClockWidget < Category
end

class Category::ComicWidget < Category
end

class Category::UrlWidget < Category
  def fields
    {
      url: nil
    }

  end
end

class Category::GcalWidget < Category
  def fields
    {
      authenticate: { type: 'link', text: 'Authenticate with Google', url: '/api/google/login?return_url=/widget/gcal/new' },
      access_token: { type: 'hidden' },
      refresh_token: { type: 'hidden' },
      calendar_id: { type: 'hidden' },
    }
  end
end

class Category::GcalResourceWidget < Category
  def fields
    {
      authenticate: { type: 'link', text: 'Authenticate with Google', url: '/api/google/login?return_url=/widget/gcal_resource/new' },
      access_token: { type: 'hidden' },
      refresh_token: { type: 'hidden' },
      resource_id: { type: 'hidden' },
    }
  end
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
