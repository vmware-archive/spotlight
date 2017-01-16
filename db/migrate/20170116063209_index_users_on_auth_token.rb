class IndexUsersOnAuthToken < ActiveRecord::Migration
  def change
    def change
      add_index :users, :auth_token, unique: true
    end
  end
end
