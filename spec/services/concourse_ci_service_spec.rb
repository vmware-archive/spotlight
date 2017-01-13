require 'rails_helper'

RSpec.describe ConcourseCiService do
  let(:opts) do
    {
      server_url: 'http://concourse.example.com',
      auth_key: 'fake-concourse-key',
      project_name: 'fake-concourse-project'
    }
  end

  describe '#build_history' do
    let(:fake_build_history) do
      [
          "665  todo-ios/tests  157  started    2016-09-16@17:54:02+0800  n/a                       4m36s\n",
          "664  todo-ios/tests  156  failed     2016-09-16@17:31:43+0800  2016-09-16@17:40:14+0800  8m31s\n",
          "663  todo-ios/tests  155  succeeded  2016-09-16@15:19:31+0800  2016-09-16@15:27:48+0800  8m17s\n",
          "661  todo-ios/tests  154  succeeded  2016-09-16@15:04:02+0800  2016-09-16@15:08:38+0800  4m36s\n"
      ]
    end

    it 'parses the build history' do
      service = ConcourseCiService.new opts
      expect(service).to receive(:repo_info).and_return(fake_build_history)

      history = service.build_history

      expected_build_history = [
        {
            id: '665',
            status: 'started',
            start: '2016-09-16T17:54:02+08:00',
            end: ''
        },
        {
          id: '664',
          status: 'failed',
          start: '2016-09-16T17:31:43+08:00',
          end: '2016-09-16T17:40:14+08:00'
        },
        {
          id: '663',
          status: 'succeeded',
          start: '2016-09-16T15:19:31+08:00',
          end: '2016-09-16T15:27:48+08:00'
        },
        {
          id: '661',
          status: 'succeeded',
          start: '2016-09-16T15:04:02+08:00',
          end: '2016-09-16T15:08:38+08:00'
        }
      ]

      expect(history).to eq(expected_build_history)
    end
  end

end
