class CiStatusController < ApplicationController
  def show
    case widget.server_type
    when 'travis_ci'
      @ci_status = TravisCiService.for_widget(widget).last_build_info
    end
  end

  private

  def widget
    @widget ||= Widget.find_by_uuid(params[:id])
  end
end
