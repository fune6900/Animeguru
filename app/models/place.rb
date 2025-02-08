class Place < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  # カスタムバリデーション
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :address, presence: true, length: { maximum: 200 }
  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/, message: "はXXX-XXXXの形式で入力してください" }
end
