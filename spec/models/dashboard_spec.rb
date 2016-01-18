require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  describe 'associations' do
    it { should have_many(:widgets) }
  end

  it 'fails - explicitly added for Gabe to be able to accept story #111128318' do
    fail
  end
end
