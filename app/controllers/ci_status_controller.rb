class CiStatusController < ApplicationController
  def show
    case widget.server_type
    when 'travis_ci'
      service_class = TravisCiService
    when 'jenkins_ci'
      service_class = JenkinsCiService
    end

    @ci_status = service_class.for_widget(widget).last_build_info
  end

  private

  def widget
    @widget ||= Widget.find_by_uuid(params[:id])
  end
end
