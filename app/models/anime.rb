class Anime < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  # カスタムバリデーション
  validates :title, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :official_site_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "は正しいURL形式で入力してください" }, allow_blank: true
end
