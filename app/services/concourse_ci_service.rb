require 'open3'

class ConcourseCiService < BaseCiService
  attr_reader :options

  def initialize options = {}
    super options

    @pipeline = options[:pipeline]
    @job = options[:job]
    @username = options[:username]
    @password = options[:password]
  end

  def repo_info(repository = @project_name, path = '', options = {})
    login

    builds_command = "#{ fly } -t #{ @project_name } builds --job #{ @pipeline }/#{ @job } -c 5"
    stdin, stdout, stderr = Open3.popen3 builds_command

    builds = []
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
          start: to_iso8601(line[4]),
          end: to_iso8601(line[5])
      }
    end
  end

  private
  def login
    login_command = "#{ fly } login -c #{ @server_url } -t #{ @project_name }"

    stdin, stdout, stderr = Open3.popen3 login_command

    # default to use basic auth for now
    stdin.puts "2"

    stdin.puts @username
    stdin.puts @password

    while stdout.gets != nil
    end
  end

  def fly
    host_os = RbConfig::CONFIG['host_os']
    case host_os
      when /darwin|mac os/
        Rails.root.join 'fly'
      else
        Rails.root.join 'fly_linux_amd64'
    end
  end

  def to_iso8601(timestamp)
    Time.parse(timestamp).iso8601 rescue ''
  end
end

