class AddProfileToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :introduction, :text
    add_column :users, :profile_image, :string
  end
end
