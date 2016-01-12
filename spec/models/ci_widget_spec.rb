require 'rails_helper'

RSpec.describe CiWidget, type: :model do
  describe 'is a type of widget' do
    it { expect(CiWidget).to be < Widget }
  end

  describe 'configuration' do
    let!(:ci_widget) { FactoryGirl.create(:ci_widget, :with_default_dashboard)}
    let(:travis_url) {'http://travis.url/repos'}
    let(:travis_auth_key) {'1234567890'}

    it 'should save the configuration' do
      ci_widget.update!(travis_url: travis_url, travis_auth_key: travis_auth_key)
      ci_widget = Widget.last.reload
      #to make sure that we are nol looking at a dirty local variable

      expect(ci_widget.travis_url).to eq travis_url
      expect(ci_widget.travis_auth_key).to eq travis_auth_key
    end
  end
end
