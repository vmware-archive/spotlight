require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  describe 'associations' do
    it { should have_many(:widgets) }
  end
end
