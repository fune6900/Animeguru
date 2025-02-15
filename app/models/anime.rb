class Anime < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  mount_uploader :image_url, AnimeImageUploader
end
