class Api::CiStatusController < Api::BaseController
  def show
    build_class = ('Ci::' + (widget.server_type + '_build').camelize).constantize

    service_class = (widget.server_type + '_service').camelize.constantize
    service = service_class.for_widget(widget)

    @ci_status = {
      repo_name: widget.project_name,
      build_history: service.build_history.map{|build_info| build_class.new(build_info) }
    }
  end

  private

  def widget
    @widget ||= Widget.find_by_uuid(params[:id])
  end
end
