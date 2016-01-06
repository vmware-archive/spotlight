require 'rails_helper'

RSpec.describe Widget, type: :model do
  describe 'associations' do
    it { should belong_to(:dashboard) }
  end

  describe 'scope' do
    describe 'active' do
      let(:dashboard) { FactoryGirl.create :dashboard }
      let!(:active) { FactoryGirl.create :ci_widget, active: true, dashboard: dashboard }
      let!(:inactive) { FactoryGirl.create :ci_widget, active: false, dashboard: dashboard }

      it 'shows active widgets' do
        expect(Widget.active).to contain_exactly active
      end
    end
  end
end
