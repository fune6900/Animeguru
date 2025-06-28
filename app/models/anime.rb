class Anime < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  mount_uploader :image_url, AnimeImageUploader

  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :official_site_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "は正しいURL形式で入力してください" }, allow_blank: true

  # ransackで許可するカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  # ransackで許可するテーブル
  def self.ransackable_associations(auth_object = nil)
    %w[seichi_memos]
  end
end
