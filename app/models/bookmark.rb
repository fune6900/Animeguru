class Bookmark < ApplicationRecord
	belongs_to :seichi_memo
	belongs_to :user

	# 同じ投稿を複数回ブックマークできないようにする
	validates :user_id, uniqueness: { scope: :seichi_memo_id, message: "すでにブックマークしています" }
end
