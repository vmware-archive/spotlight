class AddSizeToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :height, :integer
    add_column :widgets, :width, :integer
  end
end
