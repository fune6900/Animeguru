class Anime < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  mount_uploader :image_url, AnimeImageUploader

  #ransackで許可するカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end
end
