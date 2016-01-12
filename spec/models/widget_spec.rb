require 'rails_helper'

RSpec.describe Widget, type: :model do
  let(:dashboard) { FactoryGirl.create :dashboard }

  before :each do
    allow_any_instance_of(Widget).to receive(:config_keys).and_return([:foo, :bar])
  end

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

  describe 'configuration' do
    let!(:widget) { FactoryGirl.create :widget, type: 'Widget', dashboard: dashboard}

    it 'can access value of config' do
      widget.update(foo: 'bar')
      expect(widget.foo).to eq 'bar'
    end

    it 'can load value of config from json' do
      widget.update!(foo: 'bar')
      expect(Widget.last.foo).to eq 'bar'
    end
  end
end
