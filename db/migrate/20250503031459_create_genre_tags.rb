class CreateGenreTags < ActiveRecord::Migration[7.2]
  def change
    create_table :genre_tags do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :genre_tags, :name, unique: true
  end
end
