class SeichiMemoForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # 🔹 フォームで扱うデータを定義
  attribute :user_id, :integer
  attribute :title, :string
  attribute :body, :text
  attribute :anime_title, :string
  attribute :anime_official_site_url, :string
  attribute :place_name, :string
  attribute :place_address, :string
  attribute :place_postal_code, :string

  # 🔹 バリデーション
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true, length: { maximum: 1000 }
  validates :anime_title, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :place_name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :anime_official_site_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "は正しいURL形式で入力してください" }, allow_blank: true
  validates :place_address, length: { maximum: 200 }, allow_blank: true
  validates :place_postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: "はXXX-XXXXの形式で入力してください" }, allow_blank: true

  def save
    return false unless valid?

    # 🔹 既存データがあれば更新、新規なら作成
    anime = Anime.find_or_create_by(title: anime_title)
    anime.update(official_site_url: anime_official_site_url) if anime.official_site_url.blank? && anime_official_site_url.present?

    place = Place.find_or_create_by(name: place_name)
    place.update(
      address: place_address.presence || place.address,
      postal_code: place_postal_code.presence || place.postal_code
    )

    # 🔹 聖地メモを作成
    SeichiMemo.create!(
      user_id: user_id,
      anime_id: anime.id,
      place_id: place.id,
      title: title,
      body: body
    )
  end
end
