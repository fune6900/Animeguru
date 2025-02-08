class CreateSeichiMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :seichi_memos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :anime, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
