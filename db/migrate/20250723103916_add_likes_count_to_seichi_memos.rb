class AddLikesCountToSeichiMemos < ActiveRecord::Migration[7.2]
  def change
    add_column :seichi_memos, :likes_count, :integer
  end
end
