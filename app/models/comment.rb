class Comment < ApplicationRecord
  belongs_to :seichi_memo
  belongs_to :user

  validates :content, presence: true, length: { maximum: 300 }
end
