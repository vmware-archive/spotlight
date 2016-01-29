class CircleCiService < BaseCiService
  STATUSES = {
    'success' => Category::CiWidget::STATUS_PASSED,
    'fixed' => Category::CiWidget::STATUS_PASSED,
    'failed' => Category::CiWidget::STATUS_FAILED,
    'cancelled' => Category::CiWidget::STATUS_FAILED,
    'running' => Category::CiWidget::STATUS_BUILDING
  }

  def repo_info(repository=@project_name, path='', options={})
    response = connection.get do |req|
      req.url '/api/v1/project/' + repository + path + '?circle-token=' + @auth_key
      req.headers['Accept'] = 'application/json'
    end

    response.success? ? response.body : {}
  end

  def build_info(build_id, repository=@project_name)
    repo_info(repository, '/' + build_id.to_s)
  end

  def build_history(repository=@project_name, limit=5)
    repo_info = repo_info(repository)
    return [] if repo_info.empty?

    repo_info.first(limit)
  end

  def self.parse_timestamp(timestamp_string)
    Time.parse(timestamp_string).localtime.to_datetime
  end

  def self.normalized_build_entry(build)
    state = self.normalized_state_for(build['status'])
    timestamp = state == Category::CiWidget::STATUS_BUILDING ? build['start_time'] : build['stop_time']

    {
      state: state,
      committer: build['committer_name'],
      timestamp: self.parse_timestamp(timestamp)
    }
  end
end
