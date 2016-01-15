require 'rails_helper'

RSpec.describe Widget, type: :model do
  let(:dashboard) { FactoryGirl.create :dashboard }

  describe 'associations' do
    it { should belong_to(:dashboard) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:category) }
    it { should validate_length_of(:title).is_at_most(60) }
  end

  describe 'scope' do
    describe 'active' do
      let!(:active) { FactoryGirl.create :widget, active: true, dashboard: dashboard }
      let!(:inactive) { FactoryGirl.create :widget, active: false, dashboard: dashboard }

      it 'shows active widgets' do
        expect(Widget.active).to contain_exactly active
      end
    end
  end

  context 'after creation' do
    let(:widget) { FactoryGirl.build :widget, dashboard: dashboard }
    it 'has a generated uuid' do
      expect{ widget.save }.to change{ widget.uuid }
      expect(widget.uuid).to be_present
    end

    it 'remains the same when we save details' do
      widget.save!
      expect{ widget.update(title: 'Something') }.to_not change{ widget.uuid }
    end
  end

  describe '#configuration' do
    let(:project_name) { 'Example Project' }
    let(:configuration) {{ project_name: project_name }}
    let!(:widget) { FactoryGirl.create :widget, dashboard: dashboard, configuration: configuration }

    it 'allows reading valid fields' do
      expect(widget.server_url).to be_nil
    end

    it 'disallow invalid fields' do
      expect{ widget.garbage }.to raise_error 'Unknown field'
    end

    it 'allows writing valid fields' do
      expect{ widget.project_name = 'Other project' }.to change{ widget.project_name }
    end

    it 'disallow writing valid fields' do
      expect{ widget.garbage = 'Other project' }.to raise_error 'Unknown field'
    end
  end

  describe '#category' do
    let!(:widget) { FactoryGirl.create :widget, category: 'ci_widget', dashboard: dashboard}

    it 'returns a classy enum' do
      expect(widget.category).to be_a Category::CiWidget
    end

    it 'has knowledge of fields' do
      expect(widget.category.fields).to be_a Hash
    end
  end
end
