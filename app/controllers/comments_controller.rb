class CommentsController < ApplicationController
  def create
    @seichi_memo = SeichiMemo.includes(:anime, :place).find(params[:seichi_memo_id])
    @comment = @seichi_memo.comments.build(comment_params)
    @comment.user = current_user # 現在のユーザーをコメントの作成者として設定

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to seichi_memo_path(@seichi_memo), notice: "コメントを投稿しました" }
      end
    else
      @comments = @seichi_memo.comments.includes(:user)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "コメントを投稿出来ませんでした"
          render turbo_stream: turbo_stream.replace(
            "comment_form",
            partial: "comments/form",
            locals: { seichi_memo: @seichi_memo, comment: @comment }
          )
        end
        format.html do
          flash.now[:alert] = "コメントを投稿出来ませんでした"
          render "seichi_memos/show", status: :unprocessable_entity
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
