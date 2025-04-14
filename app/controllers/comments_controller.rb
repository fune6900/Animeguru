class CommentsController < ApplicationController
  def create
    @seichi_memo = SeichiMemo.includes(:anime, :place).find(params[:seichi_memo_id])
    @comment = @seichi_memo.comments.build(comment_params)
    @comment.user = current_user # 現在のユーザーをコメントの作成者として設定

    if @comment.save
      redirect_to seichi_memo_path(@seichi_memo), notice: "コメントを投稿しました"
    else
      @comments = @seichi_memo.comments.includes(:user)
      flash.now[:alert] = "コメントを投稿出来ませんでした"
      render "seichi_memos/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
