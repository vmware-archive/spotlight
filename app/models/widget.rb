class Widget < ActiveRecord::Base
  belongs_to :dashboard

  validates_presence_of :title
  validates_length_of :title, maximum: 60

  scope :active, ->{ where(active: true) }
end
