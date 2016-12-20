class JenkinsCiService < BaseCiService
  def repo_info(repository=@project_name, path='', options={})
    params = options[:params] ? '?' + options[:params] : ''
    response = connection.get do |req|
      req.url '/job/' + URI.escape(repository) + path + '/api/json' + params
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = "Basic #{@auth_key}" if @auth_key.present?
    end

    response.success? ? response.body : {}
  end

  def build_info(build_id, repository=@project_name)
    repo_info(repository, '/' + build_id.to_s)
  end

  def build_history(repository=@project_name, limit=5)
    build_history = repo_info(repository, '', params: 'tree=builds[number,building,timestamp,result,committer_name,changeSet[items[author[fullName]]],changeSets[items[author[fullName]]]]')

    build_history['builds'].first(5)
  end
end
