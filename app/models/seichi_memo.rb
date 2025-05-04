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

  # ransackで許可するテーブル
  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[anime place]
  end
end
