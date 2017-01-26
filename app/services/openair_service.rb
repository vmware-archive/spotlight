class OpenairService
  def initialize(api_client:)
    @api_client = api_client
  end

  def timesheet_statuses_for_previous_week(user_ids)
    request_template = File.read('app/views/api/openair/timesheet_status_request.xml.erb')

    start_date = Date.today.beginning_of_week - 1.week
    end_date = Date.today.beginning_of_week - 1.day

    response = @api_client.send_request(
        template: request_template.squish,
        model: 'Timesheet',
        locals: {
            user_ids: user_ids,
            start_date: start_date,
            end_date: end_date
        }
    )

    default_statuses = default_user_id_status_map(user_ids)
    statuses = user_id_status_map(response['Timesheet'])
    default_statuses.merge(statuses)
  end

  def user_ids_for_emails(user_emails)
    request_template = File.read('app/views/api/openair/user_ids_request.xml.erb')

    response = @api_client.send_request(
        template: request_template.squish,
        model: 'User',
        locals: {
            user_emails: user_emails
        }
    )

    response['User'].map { |u| u['id'] }
  end

  def self.overall_submission_status(statuses)
    return Category::OpenairWidget::STATUS_PENDING if statuses.empty?

    statuses.all? do |_, status|
      %w(S A).include? status
    end ? Category::OpenairWidget::STATUS_SUBMITTED : Category::OpenairWidget::STATUS_PENDING
  end

  private

  def default_user_id_status_map(user_ids)
    user_ids.map { |id| [id, 'M'] }.to_h
  end

  def user_id_status_map(response)
    response.map do |data|
      [data['userid'], data['status']]
    end.to_h
  end
end

class OpenairServiceFactory
  def initialize(widget)
    @widget = widget
  end

  def client
    sinclair_client = Sinclair::OpenAirApiClient.new(
                                                    username: @widget.username,
                                                    password: @widget.password,
                                                    company: @widget.company,
                                                    client: @widget.client,
                                                    key: @widget.key,
                                                    url: @widget.url
    )

    OpenairService.new(api_client: sinclair_client)
  end
end
