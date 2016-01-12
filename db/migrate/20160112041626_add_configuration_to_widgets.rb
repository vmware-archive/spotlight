class AddConfigurationToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :configuration, :string, default: '{}', null: false
  end
end
