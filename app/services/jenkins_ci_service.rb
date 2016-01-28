class JenkinsCiService
  attr_reader :connection, :server_url, :auth_key, :project_name

  STATUSES = {
    'SUCCESS' => Category::CiWidget::STATUS_PASSED,
    'FAILURE' => Category::CiWidget::STATUS_FAILED,
    nil => Category::CiWidget::STATUS_BUILDING # Jenkins returns null when its building
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
      req.url '/job/' + repository + '/api/json'
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = 'Token "' + @auth_key + '"' if @auth_key.present?
    end
  end

  def build_info(build_id, repository=@project_name)
    connection.get do |req|
      req.url '/job/' + repository + '/' + build_id.to_s + '/api/json'
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = 'Token "' + @auth_key + '"' if @auth_key.present?
    end
  end

  def build_history(repository=@project_name, limit=5)
    build_history = connection.get do |req|
      req.url '/job/' + repository + '/api/json?tree=builds[number,timestamp,result]'
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = 'Token "' + @auth_key + '"' if @auth_key.present?
    end

    build_history.body['builds'].first(5)
  end

  def last_build_info(repository=@project_name)
    payload = {
      repo_name:          repository,
      last_build_status:  nil,
      last_committer:     nil,
      last_build_time:    nil
    }

    build_response = build_info('lastBuild', repository)
    last_build = build_response.body
    last_commit = last_build['changeSet']['items'][0]

    payload[:last_build_status] = normalized_state_for(last_build['result'])
    payload[:last_build_time] = Time.at(last_build['timestamp'] / 1000).to_datetime
    payload[:last_committer] = last_commit['author']['fullName']

    payload[:build_history] = build_history(repository).map{|h| normalized_state_for(h['result']) }

    payload
  end

  private

  def normalized_state_for(state)
    STATUSES[state] || Category::CiWidget::STATUS_UNKNOWN
  end
end
