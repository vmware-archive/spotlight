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

    limit = [limit, builds_response['builds'].count].min

    (0...limit).map do |i|
      {
        'build' => builds_response['builds'][i],
        'commit' => builds_response['commits'][i]
      }
    end

    # builds_response['builds'].first(limit)
  end

  def self.parse_timestamp(timestamp_string)
    Time.parse(timestamp_string).localtime.to_datetime
  end

  def self.normalized_build_entry(build_info)
    build = build_info['build']
    commit = build_info['commit']
    state = self.normalized_state_for(build['state'])
    timestamp = state == Category::CiWidget::STATUS_BUILDING ? build['started_at'] : build['finished_at']

    {
      state: state,
      committer: commit['author_name'],
      timestamp: self.parse_timestamp(timestamp)
    }
  end
end
