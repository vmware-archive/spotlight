class JenkinsCiService < BaseCiService
  STATUSES = {
    'SUCCESS' => Category::CiWidget::STATUS_PASSED,
    'FAILURE' => Category::CiWidget::STATUS_FAILED,
    nil => Category::CiWidget::STATUS_BUILDING # Jenkins returns null when its building
  }

  def repo_info(repository=@project_name, path='', options={})
    params = options[:params] ? '?' + options[:params] : ''
    response = connection.get do |req|
      req.url '/job/' + repository + path + '/api/json' + params
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = 'Token "' + @auth_key + '"' if @auth_key.present?
    end

    response.success? ? response.body : {}
  end

  def build_info(build_id, repository=@project_name)
    repo_info(repository, '/' + build_id.to_s)
  end

  def build_history(repository=@project_name, limit=5)
    build_history = repo_info(repository, '', params: 'tree=builds[number,timestamp,result,committer_name,changeSet[items[author[fullName]]]]')

    build_history['builds'].first(5)
  end

  def last_build_info(repository=@project_name)
    payload = {
      repo_name:          repository,
      last_build_status:  nil,
      last_committer:     nil,
      last_build_time:    nil
    }

    last_build = build_info('lastBuild', repository)
    last_commit = last_build['changeSet']['items'][0]

    payload[:last_build_status] = self.class.normalized_state_for(last_build['result'])
    payload[:last_build_time] = self.class.parse_timestamp(last_build['timestamp'])
    payload[:last_committer] = last_commit.present? ? last_commit['author']['fullName'] : ''

    payload[:build_history] = build_history(repository).map{|build| self.class.normalized_build_entry(build) }

    payload
  end

  def self.parse_timestamp(timestamp_string)
    Time.at(timestamp_string / 1000).to_datetime
  end

  def self.normalized_build_entry(build)
    state = self.normalized_state_for(build['result'])
    timestamp = build['timestamp']
    commit = build['changeSet']['items'][0]

    {
      state: state,
      committer: commit.present? ? commit['author']['fullName'] : '',
      timestamp: self.parse_timestamp(timestamp)
    }
  end
end
