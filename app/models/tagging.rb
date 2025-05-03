class Tagging < ApplicationRecord
  belongs_to :seichi_memo
  belongs_to :genre_tag

  validates :genre_tag_id, uniqueness: { scope: :seichi_memo_id }
end
