class AddFavoriteAnimeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :favorite_anime, :string
  end
end
