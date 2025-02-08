class SeichiMemo < ApplicationRecord
  belongs_to :user
  belongs_to :anime
  belongs_to :place

  # カスタムバリデーション
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true, length: { maximum: 1000 }
end
