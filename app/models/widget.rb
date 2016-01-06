class Widget < ActiveRecord::Base
  belongs_to :dashboard

  scope :active, ->{ where(active: true) }

end
