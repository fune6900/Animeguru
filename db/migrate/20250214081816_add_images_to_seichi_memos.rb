class AddImagesToSeichiMemos < ActiveRecord::Migration[7.2]
  def change
    add_column :seichi_memos, :seichi_photo, :string
    add_column :seichi_memos, :scene_image, :string
  end
end
