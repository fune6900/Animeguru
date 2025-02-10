class SeichiMemosController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]
  before_action :set_seichi_memo, only: [ :show ]

  require_dependency "seichi_memo_form"

  def index
    @seichi_memos = SeichiMemo.includes(:anime, :place).order(created_at: :desc)
  end

  def show
  end

  def new
    @seichi_memo_form = SeichiMemoForm.new
  end

  def create
    @seichi_memo_form = SeichiMemoForm.new(seichi_memo_params)

    if @seichi_memo_form.save
      redirect_to seichi_memo_path(@seichi_memo_form.seichi_memo), notice: "聖地メモを投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def seichi_memo_params
    params.require(:seichi_memo_form).permit(:title, :body, :anime_title, :anime_official_site_url, :place_name, :place_address, :place_postal_code).merge(user_id: current_user.id)
  end

  def set_seichi_memo
    @seichi_memo = SeichiMemo.includes(:anime, :place).find(params[:id])
  end
end
