class TravisCiService < BaseCiService
  STATUSES = {
    'passed' => Category::CiWidget::STATUS_PASSED,
    'failed' => Category::CiWidget::STATUS_FAILED,
    'started' => Category::CiWidget::STATUS_BUILDING
  }

  def repo_info(repository=@project_name, path='', options={})
    response = connection.get do |req|
      req.url '/repos/' + repository + path
      req.headers['Accept'] = 'application/vnd.travis-ci.2+json'
      req.headers['Authorization'] = 'Token "' + @auth_key + '"'
    end

    response.success? ? response.body : {}
  end

  def build_info(build_id, repository=@project_name)
    repo_info(repository, '/builds/' + build_id.to_s)
  end

  def build_history(repository=@project_name, limit=5)
    builds_response = repo_info(repository, '/builds')

    builds_response['builds'].first(limit)
  end

  def last_build_info(repository=@project_name)
    payload = {
      repo_name:          repository,
      last_build_status:  nil,
      last_committer:     nil,
      last_build_time:    nil
    }

    repo_response = repo_info(repository)

    if last_build_id = repo_response['repo']['last_build_id']
      build_response = build_info(last_build_id, repository)

      last_build = build_response['build']
      last_commit = build_response['commit']

      payload[:last_build_status] = self.class.normalized_state_for(last_build['state'])
      build_time = last_build['finished_at'].present? ? last_build['finished_at'] : last_build['started_at']
      payload[:last_build_time] = self.class.parse_timestamp(build_time)
      payload[:last_committer] = last_commit['author_name']
    end

    payload[:build_history] = build_history(repository).map{|build| self.class.normalized_build_entry(build) }

    payload
  end

  def self.parse_timestamp(timestamp_string)
    Time.parse(timestamp_string).localtime.to_datetime
  end

  def self.normalized_build_entry(build)
    state = self.normalized_state_for(build['state'])
    timestamp = state == Category::CiWidget::STATUS_BUILDING ? build['started_at'] : build['finished_at']

    {
      state: state,
      timestamp: self.parse_timestamp(timestamp)
    }
  end
end
