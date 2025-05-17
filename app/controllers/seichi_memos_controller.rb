class SeichiMemosController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_seichi_memo, only: [ :show, :edit, :update, :destroy ]
  before_action :correct_user, only: [ :edit, :update, :destroy ]
  # 設定したprepare_meta_tagsをprivateにあってもseichi_memosコントローラー以外にも使えるようにする
  helper_method :prepare_meta_tags

  require_dependency "seichi_memo_form"

  def index
    @q = SeichiMemo.ransack(params[:q])
    @seichi_memos = @q.result(distinct: true).includes(:anime, :place, :user, :genre_tags).order(created_at: :desc).page(params[:page]).per(18)
    @jenre_tags = GenreTag.all
  end

  def show
    @seichi_memo = SeichiMemo.includes(:anime, :place, :user, :genre_tags).find(params[:id])
    # メタタグを設定
    prepare_meta_tags(@seichi_memo)
    @comment = Comment.new
    @comments = @seichi_memo.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @seichi_memo_form = SeichiMemoForm.from_session(session[:seichi_memo], "memo", session)
  end

  # 🔹 各ステップごとにセッションを更新
  def update_session
    @seichi_memo_form = SeichiMemoForm.new(seichi_memo_params.merge(current_step: params[:step]))

    if @seichi_memo_form.valid?
      @seichi_memo_form.save_to_session(session)
      head :ok  # 成功時は 200 OK を返す
    else
      render json: { errors: @seichi_memo_form.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 🔹 最終ステップでデータをデータベースに保存
  def create
    @seichi_memo_form = SeichiMemoForm.from_session(session[:seichi_memo], "confirm", session)

    if @seichi_memo_form.save
      session.delete(:seichi_memo)
      redirect_to seichi_memo_path(@seichi_memo_form.seichi_memo), notice: "聖地メモを投稿しました！"
    else
      flash.now[:alert] = "聖地メモを投稿出来ませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  # 🔹 編集画面を表示
  def edit
    @seichi_memo_form = SeichiMemoForm.new(
      user_id: @seichi_memo.user_id,
      title: @seichi_memo.title,
      body: @seichi_memo.body,
      anime_title: @seichi_memo.anime.title,
      anime_official_site_url: @seichi_memo.anime.official_site_url,
      image_url: @seichi_memo.anime.image_url,
      place_name: @seichi_memo.place.name,
      place_address: @seichi_memo.place.address,
      place_postal_code: @seichi_memo.place.postal_code,
      seichi_photo: @seichi_memo.seichi_photo,
      scene_image: @seichi_memo.scene_image,
      genre_tag_ids: @seichi_memo.genre_tags.pluck(:id)
    )
    @seichi_memo_form.seichi_memo = @seichi_memo
  end

  # 🔹 編集したデータをデータベースに保存
  def update
    @seichi_memo_form = SeichiMemoForm.from_session(session[:seichi_memo], "confirm", session)
    @seichi_memo_form.seichi_memo = @seichi_memo

    if @seichi_memo_form.update(@seichi_memo)
      session.delete(:seichi_memo)
      redirect_to seichi_memo_path(@seichi_memo_form.seichi_memo), notice: "聖地メモを更新しました！"
    else
      flash.now[:alert] = "聖地メモを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  # 🔹 削除
  def destroy
    if @seichi_memo.destroy
      redirect_to seichi_memos_path, notice: "聖地メモを削除しました！"
    else
      flash.now[:alert] = "削除に失敗しました"
      redirect_back fallback_location: seichi_memos_path
    end
  end

  def prepare_confirm
    SeichiMemoForm.from_session(session[:seichi_memo], "confirm", session)
    head :ok
  end

  def bookmarks
    @q = current_user.bookmark_seichi_memos.ransack(params[:q])
    @bookmark_seichi_memos = @q.result(distinct: true).includes(:anime, :place, :genre_tags).order(created_at: :desc).page(params[:page]).per(18)
    @jenre_tags = GenreTag.all
  end

  def autocomplete
    query = params[:term].to_s.strip

    # 聖地名だけを検索
    places = Place.where("name ILIKE ?", "%#{query}%")
                  .distinct.limit(5)
                  .map { |place| { id: "place_#{place.id}", type: "place", value: place.name } }

    # 作品タイトルだけを検索
    animes = Anime.where("title ILIKE ?", "%#{query}%")
                  .distinct.limit(5)
                  .map { |anime| { id: "anime_#{anime.id}", type: "anime", value: anime.title } }

    render json: places + animes
  end

  private

  # 🔹 Strong Parameters
  def seichi_memo_params
    params.require(:seichi_memo_form).permit(
      :title,
      :body,
      :anime_title,
      :anime_official_site_url,
      :image_url,
      :place_name,
      :place_address,
      :place_postal_code,
      :seichi_photo,
      :scene_image,
      genre_tag_ids: []
    ).merge(user_id: current_user.id)
  end

  # 🔹 指定したIDの聖地メモを取得
  def set_seichi_memo
    @seichi_memo = SeichiMemo.includes(:anime, :place, :genre_tags).find(params[:id])
  end

  # 🔹 投稿者以外がアクセスしようとした場合、リダイレクト
  def correct_user
    unless @seichi_memo.user == current_user
      flash[:alert] = "この聖地メモは編集できません"
      redirect_to root_path
    end
  end

  # 🔹 メタタグを設定
  def prepare_meta_tags(seichi_memo)
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(seichi_memo.title)}"
    set_meta_tags og: {
      site_name: 'アニめぐる',
      title: seichi_memo.title,
      description: '聖地メモの投稿です',
      type: 'website',
      url: request.original_url,
      image: image_url,
      locale: 'ja-JP'
    },
    twitter: {
      card: 'summary_large_image',
      site: '@https://https://x.com/fune_6900',
      image: image_url
    }
  end
end
