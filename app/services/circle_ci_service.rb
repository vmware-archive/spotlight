class CircleCiService
  attr_reader :connection, :server_url, :auth_key, :project_name

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

    payload[:last_build_status] = last_build['status']
    payload[:last_build_time] = Time.parse(last_build_time).localtime.to_datetime
    payload[:last_committer] = last_build['committer_name']

    payload
  end
end
