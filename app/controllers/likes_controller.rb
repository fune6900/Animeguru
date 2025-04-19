class LikesController < ApplicationController
  def create
    @seichi_memo = SeichiMemo.find(params[:seichi_memo_id])
    current_user.like(@seichi_memo)
    redirect_to seichi_memo_path(@seichi_memo)
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    seichi_memo = @like.seichi_memo
    current_user.unlike(seichi_memo)
    redirect_to seichi_memo_path(seichi_memo), status: :see_other
  end
end
