class SeichiMemosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @seichi_memos = SeichiMemo.includes(:anime, :place).order(created_at: :desc)
  end

  def new
    @seichi_memo_form = SeichiMemoForm.new
  end
end
