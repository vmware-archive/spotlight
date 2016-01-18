class Api::CiStatusController < ApplicationController
  def show
    service_class = (widget.server_type + '_service').camelize.constantize

    @ci_status = service_class.for_widget(widget).last_build_info
  end

  private

  def widget
    @widget ||= Widget.find_by_uuid(params[:id])
  end
end
