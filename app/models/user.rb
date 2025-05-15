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
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  # Usernameに関するカスタムバリデーション
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 25 }

  # その他のカスタムバリデーション
  validates :introduction, length: { maximum: 500 }, allow_blank: true
  validate :profile_image_content_type
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  # プロフィール画像のアップローダー
  mount_uploader :profile_image, ProfileImageUploader

  # プロフィール画像の拡張子バリデーション
  def profile_image_content_type
    if profile_image.present? && profile_image.file.present?
      content_type = profile_image.file.content_type
      unless allowed_image_types.include?(content_type)
        errors.add(:profile_image, "はjpg, jpeg, png, gifのいずれかの形式でアップロードしてください")
      end
    end
  end

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

  # Google認証用
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def allowed_image_types
    %w[image/jpeg image/jpg image/png image/gif]
  end
end
