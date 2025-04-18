class Like < ApplicationRecord
  belongs_to :seichi_memo
  belongs_to :user

  # 同じ投稿に複数回いいねできないようにする
  validates :user_id, uniqueness: { scope: :seichi_memo_id, message: "すでにいいねしています" }
end
