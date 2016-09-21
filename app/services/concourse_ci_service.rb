class ConcourseCiService < BaseCiService
  def repo_info(repository = @project_name, path = '', options = {})
    [
      {
        id: 665,
        pipeline: 'todo-ios/tests',
        build: 157,
        status: 'succeeded',
        start: '2016-09-16@17:31:43+0800',
        end: '2016-09-16@17:40:14+0800',
        duration: '8m31s'
      },
      {
        id: 664,
        pipeline: 'todo-ios/tests',
        build: 156,
        status: 'failed',
        start: '2016-09-16@17:31:43+0800',
        end: '2016-09-16@17:40:14+0800',
        duration: '8m31s'
      }
    ]
  end

  def build_info(build_id, repository=@project_name)
    # Noop
  end

  def build_history(repository = @project_name, limit = 5)
    repo_info
  end
end

