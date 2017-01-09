class RemoveNameAndStringFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :name, :string
    remove_column :users, :string, :string
  end
end
