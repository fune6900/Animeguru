class User < ApplicationRecord
  # 関連付け
  has_many :seichi_memos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_seichi_memos, through: :bookmarks, source: :seichi_memo
  has_many :likes, dependent: :destroy
  has_many :like_seichi_memos, through: :likes, source: :seichi_memo
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Usernameに関するカスタムバリデーション
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 25 }

  # ブックマーク機能
  def bookmark(seichi_memo)
    bookmark_seichi_memos << seichi_memo
  end

  def unbookmark(seichi_memo)
    bookmark_seichi_memos.destroy(seichi_memo)
  end

  def bookmark?(seichi_memo)
    bookmark_seichi_memos.include?(seichi_memo)
  end

  # いいね機能
  def like(seichi_memo)
    like_seichi_memos << seichi_memo
  end

  def unlike(seichi_memo)
    like_seichi_memos.destroy(seichi_memo)
  end

  def like?(seichi_memo)  
    like_seichi_memos.include?(seichi_memo)
  end
end
