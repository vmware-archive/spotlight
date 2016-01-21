class AddPositionToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :position_x, :integer, default: 0, null: false
    add_column :widgets, :position_y, :integer, default: 0, null: false
  end
end
