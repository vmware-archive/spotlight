require 'open3'

class ConcourseCiService < BaseCiService
  attr_reader :options

  def initialize options = {}
    super options

    @job = options[:job]
    @team_name = options[:team_name]
    @username = options[:username]
    @password = options[:password]
  end

  def repo_info(repository = @project_name, path = '', options = {})
    sync_command = "#{ fly } -t #{ @project_name } sync"

    login_command = "#{ fly } login -c #{ @server_url } -t #{ @project_name } -n #{ @team_name } -u #{ @username } -p #{ @password }"
    Open3.popen3 login_command

    builds_command = "#{ fly } -t #{ @project_name } builds -j #{ @job } -c 5"
    stdin, stdout, stderr = Open3.popen3 builds_command

    builds = []
    build = stdout.gets

    return [] if build.nil?

    builds << build

    while (build = stdout.gets) != nil
      builds << build
    end

    builds
  end

  def build_info(build_id, repository = @project_name)
    # Noop
  end

  def build_history(repository = @project_name, limit = 5)
    repo_info.map do |line|
      line.split ' '
    end.map do |line|
      {
        id: line[0],
        status: line[3],
        start: line[4],
        end: line[5]
      }
    end
  end

  private
  def fly
    host_os = RbConfig::CONFIG['host_os']
    case host_os
    when /darwin|mac os/
      Rails.root.join 'fly'
    else
      Rails.root.join 'fly_linux_amd64'
    end
  end

end

