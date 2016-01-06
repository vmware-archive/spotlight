class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :title, null: false
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
