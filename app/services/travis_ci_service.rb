class TravisCiService < BaseCiService
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
  end
end
