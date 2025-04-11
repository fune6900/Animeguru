class CommentsController < ApplicationController
  def create
    @seichi_memo = SeichiMemo.includes(:anime, :place).find(params[:id])
    @comment = @seichi_memo.comments.build(comment_params)
    @comment.user = current_user # 現在のユーザーをコメントの作成者として設定

    if @comment.save
      redirect_to seichi_memo_path(@seichi_memo), notice: "コメントを投稿しました。"
    else
      redirect_to seichi_memo_path(@seichi_memo), alert: "コメントを投稿出来ませんでした。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
