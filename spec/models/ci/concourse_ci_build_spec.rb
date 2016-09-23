require 'rails_helper'

RSpec.describe Ci::TravisCiService do
  it 'shows passed when it succeeds' do
    build_info = {
      id: '664',
      status: 'succeeded',
      start: '2016-09-16@17:31:43+0800',
      end: '2016-09-16@17:40:14+0800'
    }

    build = Ci::ConcourseCiBuild.new build_info

    expect(build.state).to eq Category::CiWidget::STATUS_PASSED
    expect(build.timestamp).to eq '2016-09-16@17:40:14+0800'
  end

  it 'shows failed when it fails' do
    build_info = {
      id: '664',
      status: 'failed',
      start: '2016-09-16@17:31:43+0800',
      end: '2016-09-16@17:40:14+0800'
    }

    build = Ci::ConcourseCiBuild.new build_info

    expect(build.state).to eq Category::CiWidget::STATUS_FAILED
    expect(build.timestamp).to eq '2016-09-16@17:40:14+0800'
  end

end

