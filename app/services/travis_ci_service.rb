class TravisCiService
  attr_reader :connection, :server_url, :auth_key, :project_name

  STATUSES = {
    'passed' => Category::CiWidget::STATUS_PASSED,
    'failed' => Category::CiWidget::STATUS_FAILED,
    'started' => Category::CiWidget::STATUS_BUILDING
  }

  def initialize(options={})
    @server_url = options[:server_url]
    @auth_key = options[:auth_key]
    @project_name = options[:project_name]
    @connection = Faraday.new(:url => @server_url) do |faraday|
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
  end

  def self.for_widget(widget)
    opts = {
      server_url: widget.server_url,
      auth_key: widget.auth_key,
      project_name: widget.project_name
    }
    self.new(opts)
  end

  def repo_info(repository=@project_name)
    connection.get do |req|
      req.url '/repos/' + repository
      req.headers['Accept'] = 'application/vnd.travis-ci.2+json'
      req.headers['Authorization'] = 'Token "' + @auth_key + '"'
    end
  end

  def build_info(build_id, repository=@project_name)
    connection.get do |req|
      req.url '/repos/' + repository + '/builds/' + build_id.to_s
      req.headers['Accept'] = 'application/vnd.travis-ci.2+json'
      req.headers['Authorization'] = 'Token "' + @auth_key + '"'
    end
  end

  def build_history(repository=@project_name, limit=5)
    builds_response = connection.get do |req|
      req.url '/repos/' + repository + '/builds'
      req.headers['Accept'] = 'application/vnd.travis-ci.2+json'
      req.headers['Authorization'] = 'Token "' + @auth_key + '"'
    end

    builds_response.body['builds'].first(limit)
  end

  def last_build_info(repository=@project_name)
    payload = {
      repo_name:          repository,
      last_build_status:  nil,
      last_committer:     nil,
      last_build_time:    nil
    }

    repo_response = repo_info(repository)

    if last_build_id = repo_response.body['repo']['last_build_id']
      build_response = build_info(last_build_id, repository)

      last_build = build_response.body['build']
      last_commit = build_response.body['commit']

      payload[:last_build_status] = normalized_state_for(last_build['state'])
      build_time = last_build['finished_at'].present? ? last_build['finished_at'] : last_build['started_at']
      payload[:last_build_time] = parse_timestamp(build_time)
      payload[:last_committer] = last_commit['author_name']
    end

    payload[:build_history] = build_history(repository).map{|build| normalized_build_entry(build) }

    payload
  end

  private

  def parse_timestamp(timestamp_string)
    Time.parse(timestamp_string).localtime.to_datetime
  end

  def normalized_build_entry(build)
    state = normalized_state_for(build['state'])
    timestamp = state == Category::CiWidget::STATUS_BUILDING ? build['started_at'] : build['finished_at']

    {
      state: state,
      timestamp: parse_timestamp(timestamp)
    }
  end

  def normalized_state_for(state)
    STATUSES[state] || Category::CiWidget::STATUS_UNKNOWN
  end
end
