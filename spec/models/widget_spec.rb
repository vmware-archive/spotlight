require 'rails_helper'

RSpec.describe Widget, type: :model do
  let(:dashboard) { FactoryGirl.create :dashboard }

  describe 'associations' do
    it { should belong_to(:dashboard) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(60) }
  end

  describe 'scope' do
    describe 'active' do
      let!(:active) { FactoryGirl.create :ci_widget, active: true, dashboard: dashboard }
      let!(:inactive) { FactoryGirl.create :ci_widget, active: false, dashboard: dashboard }

      it 'shows active widgets' do
        expect(Widget.active).to contain_exactly active
      end
    end
  end

  describe 'before_save' do
    let(:widget) { FactoryGirl.build :ci_widget, dashboard: dashboard }
    it 'sets a uuid' do
      expect(widget.uuid).to be_nil
      widget.save!
      expect(widget.uuid).to be
    end
  end
end
