class User < ActiveRecord::Base
  validates_uniqueness_of :email

  before_create :generate_auth_token

  def generate_auth_token
    self.auth_token ||= SecureRandom.uuid
  end
end
