require 'open3'

class ConcourseCiService < BaseCiService
  def repo_info(repository = @project_name, path = '', options = {})
    fly = Rails.root.join("fly")

    login_command = "#{ fly } login -c https://ci.pivotal-sg.com/ -t aws -n foo -u baz -p bar"
    Open3.popen3 login_command

    builds_command = "#{ fly } -t aws builds -j todo-ios/tests -c 5"
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

  def build_info(build_id, repository=@project_name)
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
end

