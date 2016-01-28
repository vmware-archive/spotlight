class CircleCiService
  attr_reader :connection, :server_url, :auth_key, :project_name

  STATUSES = {
    'success' => Category::CiWidget::STATUS_PASSED,
    'fixed' => Category::CiWidget::STATUS_PASSED,
    'failed' => Category::CiWidget::STATUS_FAILED,
    'cancelled' => Category::CiWidget::STATUS_FAILED,
    'running' => Category::CiWidget::STATUS_BUILDING
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
      req.url '/api/v1/project/' + repository + '?circle-token=' + @auth_key
      req.headers['Accept'] = 'application/json'
    end
  end

  def build_info(build_id, repository=@project_name)
    connection.get do |req|
      req.url '/api/v1/project/' + repository + '/' + build_id.to_s + '?circle-token=' + @auth_key
      req.headers['Accept'] = 'application/json'
    end
  end

  def build_history(repository=@project_name, limit=5)
    repo_info = repo_info(repository)
    return [] if repo_info.body.empty?

    repo_info.body.first(limit)
  end

  def last_build_info(repository=@project_name)
    payload = {
      repo_name:          repository,
      last_build_status:  nil,
      last_committer:     nil,
      last_build_time:    nil
    }

    build_response = repo_info
    last_build = build_response.body.try(:first)
    last_build_time = last_build['stop_time'].present? ? last_build['stop_time'] : last_build['usage_queued_at']

    payload[:build_history] = build_response.body.empty? ? [] : build_response.body.first(5).map{|build| normalized_build_entry(build) }

    payload[:last_build_status] = normalized_state_for(last_build['status'])
    payload[:last_build_time] = parse_timestamp(last_build_time)
    payload[:last_committer] = last_build['committer_name']

    payload
  end

  private

  def parse_timestamp(timestamp_string)
    Time.parse(timestamp_string).localtime.to_datetime
  end

  def normalized_build_entry(build)
    state = normalized_state_for(build['status'])
    timestamp = state == Category::CiWidget::STATUS_BUILDING ? build['start_time'] : build['stop_time']

    {
      state: state,
      timestamp: parse_timestamp(timestamp)
    }
  end

  def normalized_state_for(state)
    STATUSES[state] || Category::CiWidget::STATUS_UNKNOWN
  end
end
