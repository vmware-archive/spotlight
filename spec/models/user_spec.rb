require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_uniqueness_of(:email) }

  it 'generates an auth token after creation' do
    user = User.create! email: 'user@email.com'

    expect(user.auth_token).not_to be_nil
  end
end
