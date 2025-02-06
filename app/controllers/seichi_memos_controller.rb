class SeichiMemosController < ApplicationController
  def index
    @seichi_memos = SeichiMemo.includes(:anime, :place).order(created_at: :desc)
  end
end
