class AddDefaultDashboard < ActiveRecord::Migration
  def self.up
    Dashboard.create(title: 'Default Dashboard')
  end

  def self.down
    Dashboard.destroy_all
  end
end
