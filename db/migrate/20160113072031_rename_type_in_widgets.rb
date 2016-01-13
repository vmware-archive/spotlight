class RenameTypeInWidgets < ActiveRecord::Migration
  def change
    change_column :widgets, :type, :string, default: nil
    rename_column :widgets, :type, :category
  end
end
