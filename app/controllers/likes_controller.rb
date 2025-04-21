class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @seichi_memo = SeichiMemo.find(params[:seichi_memo_id])
    current_user.like(@seichi_memo)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to seichi_memo_path(@seichi_memo) }
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @seichi_memo = @like.seichi_memo
    current_user.unlike(@seichi_memo)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to seichi_memo_path(@seichi_memo), status: :see_other }
    end
  end
end
