class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @seichi_memo = SeichiMemo.find(params[:seichi_memo_id])
    current_user.bookmark(@seichi_memo)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to seichi_memo_path(@seichi_memo) } # 🔹 notice削除
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @seichi_memo = @bookmark.seichi_memo
    current_user.unbookmark(@seichi_memo)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to seichi_memo_path(@seichi_memo), status: :see_other } # 🔹 notice削除
    end
  end
end
