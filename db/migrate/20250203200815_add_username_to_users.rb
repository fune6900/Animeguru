class AddUsernameToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :username, :string, default: "", null: false
    add_index :users, :username, unique: true
  end
end
