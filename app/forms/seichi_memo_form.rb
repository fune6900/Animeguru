class SeichiMemoForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # 🔹 フォームで扱うデータを定義
  attribute :user_id, :integer
  attribute :title, :string
  attribute :body, :string
  attribute :anime_title, :string
  attribute :anime_official_site_url, :string
  attribute :place_name, :string
  attribute :place_address, :string
  attribute :place_postal_code, :string
  attribute :seichi_photo
  attribute :scene_image
  attribute :image_url

  # 🔹 ステップ管理用
  attr_accessor :current_step, :seichi_memo

  # 🔹 バリデーション（ステップごとに適用）
  validates :title, presence: true, length: { maximum: 30 }, if: -> { current_step == "memo" }
  validates :body, presence: true, length: { maximum: 1000 }, if: -> { current_step == "memo" }
  validates :anime_title, presence: true, length: { maximum: 100 }, if: -> { current_step == "anime" }
  validates :place_name, presence: true, length: { maximum: 100 }, if: -> { current_step == "place" }
  validates :anime_official_site_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "は正しいURL形式で入力してください" }, allow_blank: true
  validates :place_address, length: { maximum: 200 }, allow_blank: true
  validates :place_postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: "はXXX-XXXXの形式で入力してください" }, allow_blank: true

  validate :validate_image_extensions

  # 🔹 セッションデータを元にフォームオブジェクトを作成
  def self.from_session(session_data, step)
    new(session_data || {}).tap do |form|
      form.current_step = step
    end
  end

  # 🔹 セッションにデータを保存
  def save_to_session(session)
    session[:seichi_memo] ||= {}

    session[:seichi_memo].merge!(to_h)

    session[:seichi_memo][:seichi_photo_url] = seichi_photo.url if seichi_photo.present?
    session[:seichi_memo][:scene_image_url] = scene_image.url if scene_image.present?
    session[:seichi_memo][:image_url] = image_url.url if image_url.present?
  end

  # 🔹 最終ステップでデータベースに保存
  def save
    return false unless valid?

    # 🔹 既存の作品情報を再利用 or 作成
    anime = Anime.find_or_create_by(title: anime_title)
    anime.update(
      official_site_url: anime_official_site_url.presence || anime.official_site_url,
      image_url: session[:seichi_memo][:image_url]
    )

    # 🔹 既存の聖地情報を取得 or 作成
    place = Place.find_or_create_by(name: place_name)
    place.update(
      address: place_address.presence || place.address,
      postal_code: place_postal_code.presence || place.postal_code
    )

    # 🔹 聖地メモを作成
    @seichi_memo = SeichiMemo.create!(
      user_id: user_id,
      anime_id: anime.id,
      place_id: place.id,
      title: title,
      body: body,
      seichi_photo: session[:seichi_memo][:seichi_photo_url],
      scene_image: session[:seichi_memo][:scene_image_url]
    )

    true
  end

  # 🔹 既存の `SeichiMemo` を更新
  def update(seichi_memo)
    return false unless valid?

    # 🔹 既存の作品情報を更新
    anime = Anime.find_or_create_by(title: anime_title)
    anime.update(
      official_site_url: anime_official_site_url.presence || anime.official_site_url,
      image_url: session[:seichi_memo][:image_url]
    )

    # 🔹 既存の聖地情報を更新
    place = Place.find_or_create_by(name: place_name)
    place.update(
      address: place_address.presence || place.address,
      postal_code: place_postal_code.presence || place.postal_code
    )

    # 🔹 聖地メモの情報を更新
    seichi_memo.update(
      title: title,
      body: body,
      anime_id: anime.id,
      place_id: place.id,
      seichi_photo: session[:seichi_memo][:seichi_photo_url] || seichi_memo.seichi_photo,
      scene_image: session[:seichi_memo][:scene_image_url] || seichi_memo.scene_image
    )
  end

  # 🔹 画像の拡張子をチェックするカスタムバリデーション
  def validate_image_extensions
    allowed_extensions = %w[jpg jpeg png gif webp]

    if seichi_photo.present? && !valid_extension?(seichi_photo, allowed_extensions)
      errors.add(:seichi_photo, "は jpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
    end

    if scene_image.present? && !valid_extension?(scene_image, allowed_extensions)
      errors.add(:scene_image, "は jpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
    end
  end

  # 🔹 persisted? メソッド
  def persisted?
    seichi_memo.present? && seichi_memo.id.present?
  end

  private

  def valid_extension?(file, allowed_extensions)
    return false unless file.respond_to?(:original_filename)

    extension = file.original_filename.split(".").last&.downcase
    allowed_extensions.include?(extension)
  end
end
