class AddUuidToWidgets < ActiveRecord::Migration
  def self.up
    add_column :widgets, :uuid, :string

    Widget.where(uuid: nil).each do |widget|
      widget.update(uuid: SecureRandom.uuid)
    end

    change_column :widgets, :uuid, :string, null: false
    add_index :widgets, [:uuid], :unique => true
  end

  def self.down
    remove_index :widgets, [:uuid]
    remove_column :widgets, :uuid
  end
end
