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
      url: { field_type: 'text' }
    }

  end
end

class Category::GcalWidget < Category
  def fields
    {
      authenticate: { field_type: 'link', text: 'Authenticate with Google', url: '/api/google/login?return_url=/widget/gcal/new' },
      access_token: { field_type: 'hidden' },
      refresh_token: { field_type: 'hidden' },
      calendar_id: { field_type: 'hidden' },
    }
  end
end

class Category::GcalResourceWidget < Category
  def fields
    {
      authenticate: { field_type: 'link', text: 'Authenticate with Google', url: '/api/google/login?return_url=/widget/gcal_resource/new' },
      access_token: { field_type: 'hidden' },
      refresh_token: { field_type: 'hidden' },
      resource_id: { field_type: 'hidden' },
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
      server_type: { field_type: 'select', options: [:travis_ci, :jenkins_ci, :circle_ci, :concourse_ci]},
      server_url: { field_type: 'text' },
      project_name: { field_type: 'text' },
      auth_key: { field_type: 'text' }
    }
  end
end

class Category::CiConcourseWidget < Category::CiWidget
  def fields
    {
      server_type: { field_type: 'hidden', value: 'concourse_ci' },
      server_url: { field_type: 'text' },
      project_name: { field_type: 'text' },
      pipeline: { field_type: 'text' },
      job: { field_type: 'text' },
      username: { field_type: 'text' },
      password: { field_type: 'text' }
    }
  end
end

class Category::OpenairWidget < Category
  STATUS_SUBMITTED = 'submitted'
  STATUS_PENDING = 'pending'

  def fields
    {
        username: { field_type: 'text' },
        password: { field_type: 'text' },
        company: { field_type: 'text' },
        client: { field_type: 'text' },
        key: { field_type: 'text' },
        url: { field_type: 'text' },
        user_emails: { field_type: 'text', format: 'csv' }
    }
  end
end
