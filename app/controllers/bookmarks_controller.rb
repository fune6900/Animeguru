class BookmarksController < ApplicationController
  def create
    @seichi_memo = SeichiMemo.find(params[:seichi_memo_id])
    current_user.bookmark(@seichi_memo)
    redirect_to seichi_memo_path(@seichi_memo), notice: "聖地メモをブックマークしました！"
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    seichi_memo = @bookmark.seichi_memo
    current_user.unbookmark(seichi_memo)
    redirect_to seichi_memo_path(seichi_memo), notice: "ブックマークを解除しました！", status: :see_other
  end
end
