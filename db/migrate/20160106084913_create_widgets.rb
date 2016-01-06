class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :title, null: false
      t.string :type, default: 'CiWidget', null: false
      t.boolean :active, default: true
      t.integer :dashboard_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
