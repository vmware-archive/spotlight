require 'openair_service'

class Api::OpenairController < Api::BaseController
  def show
    openair_service = openair_service_for(widget)

    user_ids = openair_service.user_ids_for_emails(widget.user_emails)
    timesheet_statuses = openair_service.timesheet_statuses_for_previous_week(user_ids)

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
