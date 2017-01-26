require_relative '../../app/services/openair_service'

RSpec.describe OpenairService do
  subject { OpenairService.new(api_client: mock_sinclair_client) }
  let(:mock_sinclair_client) { double('Sinclair::OpenAirApiClient') }

  describe '#user_ids_for_emails' do
    let(:user1) { 'user1@example.com' }
    let(:user2) { 'user2@example.com' }
    let(:user3) { 'user3@example.com' }

    let(:user_emails) { [user1, user2, user3] }

    it 'returns the ids for the OpenAir users with the emails given' do
      expect(mock_sinclair_client)
          .to receive(:send_request)
                  .with(
                      template: instance_of(String),
                      model: 'User',
                      locals: {
                          user_emails: user_emails
                      }
                  )
                  .and_return(
                      {
                          'User' => [
                              {'id' => '1', 'email' => user1},
                              {'id' => '2', 'email' => user2},
                              {'id' => '3', 'email' => user3}
                          ]
                      }
                  )

      user_ids = subject.user_ids_for_emails(user_emails)

      expect(user_ids).to eq %w(1 2 3)
    end
  end

  describe '#timesheet_status_for_previous_week' do
    let(:target_date) { Date.new(2017, 1, 16) }

    let(:timesheet_data) do
      {'Timesheet' => [{'userid' => '1', 'status' => 'S'},
                       {'userid' => '2', 'status' => 'O'},
                       {'userid' => '3', 'status' => 'X'}]
      }
    end

    around do |example|
      Timecop.travel(target_date) do
        example.run
      end
    end

    it 'returns the timesheet status of every user as a hash' do
      expect(mock_sinclair_client).to receive(:send_request).and_return(timesheet_data)

      statuses = subject.timesheet_statuses_for_previous_week(%w(1 2 3))
      expect(statuses).to eq({
                                 '1' => 'S',
                                 '2' => 'O',
                                 '3' => 'X'
                             })

    end

    context 'on Monday, 16 Jan' do
      let(:target_date) { Date.new(2017, 1, 16) }

      it 'gets the timesheet statuses for the week of 9 Jan' do
        expect(mock_sinclair_client)
            .to receive(:send_request)
                    .with(template: instance_of(String),
                          model: 'Timesheet',
                          locals: {
                              user_ids: %w(1 2 3),
                              start_date: Date.new(2017, 1, 9),
                              end_date: Date.new(2017, 1, 15)
                          }
                    ).and_return(timesheet_data)

        subject.timesheet_statuses_for_previous_week(%w(1 2 3))
      end
    end

    context 'on Friday, 20 Jan' do
      let(:target_date) { Date.new(2017, 1, 20) }

      it 'gets the timesheet statuses for the week of 9 Jan' do
        expect(mock_sinclair_client)
            .to receive(:send_request)
                    .with(template: instance_of(String),
                          model: 'Timesheet',
                          locals: {
                              user_ids: %w(3 4),
                              start_date: Date.new(2017, 1, 9),
                              end_date: Date.new(2017, 1, 15)
                          }
                    ).and_return(timesheet_data)

        subject.timesheet_statuses_for_previous_week(%w(3 4))
      end
    end

    context 'on Monday, 23 Jan' do
      let(:target_date) { Date.new(2017, 1, 23) }

      it 'gets the timesheet statuses for the week of 16 Jan' do
        expect(mock_sinclair_client)
            .to receive(:send_request)
                    .with(template: instance_of(String),
                          model: 'Timesheet',
                          locals: {
                              user_ids: %w(5 6),
                              start_date: Date.new(2017, 1, 16),
                              end_date: Date.new(2017, 1, 22)
                          }
                    ).and_return(timesheet_data)

        subject.timesheet_statuses_for_previous_week(%w(5 6))
      end
    end

    context 'when any user has not created a timesheet' do
      it 'adds a default value of M for that user' do
        expect(mock_sinclair_client).to receive(:send_request).and_return({'Timesheet' => []})

        timesheet_statuses = subject.timesheet_statuses_for_previous_week(%w(1 2 3))

        expect(timesheet_statuses).to eq({'1' => 'M', '2' => 'M', '3' => 'M'})
      end

      it 'overrides the default value after the user creates their timesheet' do
        expect(mock_sinclair_client).to receive(:send_request)
                                            .and_return({'Timesheet' => [{'userid' => '1', 'status' => 'S'}]})

        timesheet_statuses = subject.timesheet_statuses_for_previous_week(%w(1 2))

        expect(timesheet_statuses).to eq({'1' => 'S', '2' => 'M'})
      end
    end
  end

  describe '.overall_submission_status' do
    context 'when there are no timesheets' do
      let(:statuses) { {} }

      specify do
        expect(OpenairService.overall_submission_status(statuses)).to eq Category::OpenairWidget::STATUS_PENDING
      end
    end

    context 'when all timesheets have been submitted' do
      let(:statuses) do
        { '1' => 'S', '2' => 'S', '3' => 'S' }
      end

      specify do
        expect(OpenairService.overall_submission_status(statuses)).to eq Category::OpenairWidget::STATUS_SUBMITTED
      end

      context 'when any timesheet has been accepted' do
        let(:statuses) do
          { '1' => 'S', '2' => 'A', '3' => 'A' }
        end

        specify do
          expect(OpenairService.overall_submission_status(statuses)).to eq Category::OpenairWidget::STATUS_SUBMITTED
        end
      end

      context 'when any timesheet has been rejected' do
        let(:statuses) do
          { '1' => 'S', '2' => 'R', '3' => 'A' }
        end

        specify do
          expect(OpenairService.overall_submission_status(statuses)).to eq Category::OpenairWidget::STATUS_PENDING
        end
      end
    end

    context 'when any timesheet has not been submitted' do
      let(:statuses) do
        { '1' => 'O', '2' => 'S', '3' => 'S' }
      end

      specify do
        expect(OpenairService.overall_submission_status(statuses)).to eq Category::OpenairWidget::STATUS_PENDING
      end
    end
  end
end
