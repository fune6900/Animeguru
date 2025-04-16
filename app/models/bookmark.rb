class Bookmark < ApplicationRecord
	belongs_to :seichi_memo
	belongs_to :user

	# 同じ投稿を複数回ブックマークできないようにする
	validates :user_id, uniqueness: { scope: :post_id, , message: "すでにブックマークしています" }
end
