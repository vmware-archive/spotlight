require 'openair_service'

class Api::OpenairController < Api::BaseController
  def show
    timesheet_statuses = openair_service_for(widget)
                             .timesheet_statuses_for_previous_week(widget.user_ids)

    @submission_status = OpenairService.overall_submission_status(timesheet_statuses)
  end

  private

  def widget
    @widget ||= Widget.find_by_uuid(params[:id])
  end

  def openair_service_for(widget)
    ::OpenairServiceFactory.new(widget).client
  end
end
