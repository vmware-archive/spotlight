class Widget < ActiveRecord::Base
  belongs_to :dashboard

  validates_presence_of :title
  validates_length_of :title, maximum: 60

  scope :active, ->{ where(active: true) }

  before_save :setup_uuid

  private

  def setup_uuid
    self.uuid = SecureRandom.uuid
  end
end
