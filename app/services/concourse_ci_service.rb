require 'open3'

class ConcourseCiService < BaseCiService
  def repo_info(repository = @project_name, path = '', options = {})
    fly = Rails.root.join("fly")
    login_command = "#{ fly } login -c https://ci.pivotal-sg.com/ -t aws"

    stdin, stdout, stderr = Open3.popen3 login_command
    stdin.puts token

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

    # ["664  todo-ios/tests  156  failed     2016-09-16@17:31:43+0800  2016-09-16@17:40:14+0800  8m31s\n",
    #  "663  todo-ios/tests  155  succeeded  2016-09-16@15:19:31+0800  2016-09-16@15:27:48+0800  8m17s\n",
    #  "661  todo-ios/tests  154  succeeded  2016-09-16@15:04:02+0800  2016-09-16@15:08:38+0800  4m36s\n"]
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

  private
  def token
    'a-fake-token'
  end

end

