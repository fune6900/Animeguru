class SeichiMemo < ApplicationRecord
  belongs_to :user
  belongs_to :anime
  belongs_to :place
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :genre_tags, through: :taggings

  mount_uploader :seichi_photo, SeichiPhotoUploader
  mount_uploader :scene_image, SceneImageUploader

  #  🔹 バリデーション
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true, length: { maximum: 500 }

  # ransackで許可するテーブル
  def self.ransackable_attributes(auth_object = nil)
    %w[title created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[anime place genre_tags]
  end
end
