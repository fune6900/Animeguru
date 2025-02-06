class CreateAnimes < ActiveRecord::Migration[7.2]
  def change
    create_table :animes do |t|
      t.string :title, null: false
      t.string :official_site_url

      t.timestamps
    end
    
    add_index :animes, :title, unique: true
  end
end
