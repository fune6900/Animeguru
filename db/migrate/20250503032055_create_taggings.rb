class CreateTaggings < ActiveRecord::Migration[7.2]
  def change
    create_table :taggings do |t|
      t.references :seichi_memo, null: false, foreign_key: true
      t.references :genre_tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :taggings, [ :seichi_memo_id, :genre_tag_id ], unique: true
  end
end
