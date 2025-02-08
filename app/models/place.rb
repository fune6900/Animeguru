class Place < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  # カスタムバリデーション
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :address, length: { maximum: 200 }, allow_blank: true
  validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: "はXXX-XXXXの形式で入力してください" }, allow_blank: true
end
