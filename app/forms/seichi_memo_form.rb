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
  attribute :genre_tag_ids, default: []

  # 🔹 ステップ管理用
  attr_accessor :current_step, :seichi_memo,
                :seichi_photo_cache, :scene_image_cache, :image_url_cache

  # 🔹 バリデーション（ステップごとに適用）
  validates :title, presence: true, length: { maximum: 30 }, if: -> { current_step == "memo" }
  validates :body, presence: true, length: { maximum: 1000 }, if: -> { current_step == "memo" }
  validates :anime_title, presence: true, length: { maximum: 100 }, if: -> { current_step == "anime" }
  validates :place_name, presence: true, length: { maximum: 100 }, if: -> { current_step == "place" }
  validates :anime_official_site_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "は正しいURL形式で入力してください" }, allow_blank: true, if: -> { current_step == "anime" }
  validates :place_address, length: { maximum: 200 }, allow_blank: true, if: -> { current_step == "place" }
  validates :place_postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: "はXXX-XXXXの形式で入力してください" }, allow_blank: true, if: -> { current_step == "place" }
  validates :genre_tag_ids, length: { maximum: 3, message: "は3つまでしか選択できません" }, if: -> { current_step == "anime" }

  validate :validate_image_extensions

  # 🔹 セッションデータを元にフォームオブジェクトを作成
  def self.from_session(session_data, step, session)
    cleaned_data = (session_data || {}).except("id")

    new(cleaned_data).tap do |form|
      form.current_step = step
      if session_data&.dig("id").present?
        form.seichi_memo = SeichiMemo.find_by(id: session_data["id"])
      end
      form.assign_cache(session) if session_data.present?
    end
  end

  # 🔹 キャッシュ名から再セット
  def assign_cache(session)
    return unless session[:seichi_memo]

    # 🔹 seichi_photo の復元
    if session[:seichi_memo]["seichi_photo_cache"].present?
      uploader = SeichiPhotoUploader.new
      uploader.retrieve_from_cache!(session[:seichi_memo]["seichi_photo_cache"])
      self.seichi_photo = uploader
    elsif editing?
      self.seichi_photo = @seichi_memo.seichi_photo
    end

    # 🔹 scene_image の復元
    if session[:seichi_memo]["scene_image_cache"].present?
      uploader = SceneImageUploader.new
      uploader.retrieve_from_cache!(session[:seichi_memo]["scene_image_cache"])
      self.scene_image = uploader
    elsif editing?
      self.scene_image = @seichi_memo.scene_image
    end

    # 🔹 image_url の復元
    if session[:seichi_memo]["image_url_cache"].present?
      uploader = AnimeImageUploader.new
      uploader.retrieve_from_cache!(session[:seichi_memo]["image_url_cache"])
      self.image_url = uploader
    elsif editing?
      self.image_url = @seichi_memo.anime.image_url
    end
  end

  # 🔹 セッション保存
  def save_to_session(session)
    session[:seichi_memo] ||= {}
    session[:seichi_memo].merge!(attributes.except("seichi_photo", "scene_image", "image_url"))

    if seichi_photo.present?
      uploader = SeichiPhotoUploader.new
      uploader.cache!(seichi_photo)
      session[:seichi_memo]["seichi_photo_cache"] = uploader.cache_name
    end

    if scene_image.present?
      uploader = SceneImageUploader.new
      uploader.cache!(scene_image)
      session[:seichi_memo]["scene_image_cache"] = uploader.cache_name
    end

    if image_url.present?
      uploader = AnimeImageUploader.new
      uploader.cache!(image_url)
      session[:seichi_memo]["image_url_cache"] = uploader.cache_name
    end
  end

  # 🔹 最終ステップでデータベースに保存
  def save
    return false unless valid?

    # 🔹 既存の作品情報を再利用 or 作成
    anime = Anime.find_or_create_by(title: anime_title)
    anime.update(
      official_site_url: anime_official_site_url.presence || anime.official_site_url,
      image_url: image_url
    )

    # 🔹 既存の聖地情報を取得 or 作成
    place = Place.find_or_create_by(name: place_name)
    place.address = place_address.presence || place.address
    place.postal_code = place_postal_code.presence || place.postal_code
    place.save!

    # 🔹 聖地メモを作成
    @seichi_memo = SeichiMemo.create!(
      user_id: user_id,
      anime_id: anime.id,
      place_id: place.id,
      title: title,
      body: body,
      seichi_photo: seichi_photo,
      scene_image: scene_image
    )

    # 🔹 タグの関連付け
    Array(genre_tag_ids).reject(&:blank?).each do |genre_tag_id|
      @seichi_memo.taggings.create!(genre_tag_id: genre_tag_id)
    end

    true
  end

  # 🔹 既存の `SeichiMemo` を更新
  def update(seichi_memo)
    return false unless valid?

    # 🔹 既存の作品情報を更新
    anime = Anime.find_or_create_by(title: anime_title)
    anime.update(
      official_site_url: anime_official_site_url.presence || anime.official_site_url,
      image_url: image_url
    )

    # 🔹 既存の聖地情報を更新
    place = Place.find_or_create_by(name: place_name)
    place.address = place_address.presence || place.address
    place.postal_code = place_postal_code.presence || place.postal_code
    place.save!

    # 🔹 聖地メモの情報を更新
    seichi_memo.update(
      title: title,
      body: body,
      anime_id: anime.id,
      place_id: place.id,
      seichi_photo: seichi_photo,
      scene_image: scene_image
    )

    # 🔹 タグの関連付けを更新
    seichi_memo.taggings.destroy_all
    Array(genre_tag_ids).reject(&:blank?).each do |genre_tag_id|
      seichi_memo.taggings.create!(genre_tag_id: genre_tag_id)
    end

    true
  end

  # 🔹 画像の拡張子をチェックするカスタムバリデーション
  def validate_image_extensions
    allowed_extensions = %w[jpg jpeg png gif webp]

    if current_step == "memo"
      if seichi_photo.present? && !valid_extension?(seichi_photo, allowed_extensions)
        errors.add(:seichi_photo, "は jpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
      end

      if scene_image.present? && !valid_extension?(scene_image, allowed_extensions)
        errors.add(:scene_image, "は jpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
      end
    end

    if current_step == "anime"
      if image_url.present? && !valid_extension?(image_url, allowed_extensions)
        errors.add(:image_url, "は jpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
      end
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

  def editing?
    seichi_memo.present? && seichi_memo.persisted?
  end
end
