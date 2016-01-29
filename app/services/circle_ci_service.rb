class CircleCiService < BaseCiService
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
end
