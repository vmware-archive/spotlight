class ChangeColumnConfigurationInWidgets < ActiveRecord::Migration
  def change
    change_column :widgets, :configuration, :string, default: nil
    change_column :widgets, :configuration, :json, using: '(configuration::json)'
    change_column :widgets, :configuration, :json, default: {}
  end
end
