require 'rails_helper'

describe WidgetHelper, :type => :helper do
  describe 'widgets_hash' do
    let(:widget1) { FactoryGirl.create :widget, :with_default_dashboard }
    let(:widget2) { FactoryGirl.create :widget, :with_default_dashboard }
    let(:widgets) do
      [ widget1, widget2 ]
    end

    it 'returns the hash of widgets' do
      result = widgets_hash(widgets)

      expect(result[0][:uuid]).to eq widget1.uuid
      expect(result[1][:uuid]).to eq widget2.uuid
    end

    it 'has all the keys' do
      hash = widgets_hash(widgets).first
      expect(hash.keys).to include(:uuid, :title, :layout, :widgetPath)
      expect(hash[:layout].keys).to include(:w, :h, :x, :y)
    end
  end
end
