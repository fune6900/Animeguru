class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @seichi_memo = SeichiMemo.includes(:anime, :place).find(params[:seichi_memo_id])
    @comment = @seichi_memo.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:comment_notice] = "コメントを投稿しました。"
          render :create
        end
        format.html { redirect_to seichi_memo_path(@seichi_memo),  flash: { comment_notice: "コメントを投稿しました。" } }
      end
    else
      @comments = @seichi_memo.comments.includes(:user)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:comment_alert] = "コメントを投稿出来ませんでした"
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "shared/flash_message_turbo")
          ]
        end
        format.html { redirect_to seichi_memo_path(@seichi_memo), flash: { comment_alert: "コメントを投稿出来ませんでした" } }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])

    if @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          flash.now[:comment_notice] = "コメントを削除しました"
          render :destroy
        end
        format.html { redirect_to seichi_memo_path(@comment.seichi_memo), flash: { comment_notice: "コメントを削除しました" } }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:comment_alert] = "コメントを削除出来ませんでした"
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "shared/flash_message_turbo")
          ]
        end
        format.html { redirect_to seichi_memo_path(@comment.seichi_memo), flash: { comment_alert: "コメントを削除出来ませんでした" } }
      end
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
    @seichi_memo = @comment.seichi_memo
  end

  def update
    @comment = current_user.comments.find(params[:id])

    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:comment_notice] = "コメントを編集しました。"
          render :update
        end
        format.html { redirect_to seichi_memo_path(@comment.seichi_memo), flash: { comment_notice: "コメントを編集しました。" } }
      end
    else
      @seichi_memo = @comment.seichi_memo
      @comments = @seichi_memo.comments.includes(:user)

      respond_to do |format|
        format.turbo_stream do
          flash.now[:comment_alert] = "コメントの編集に失敗しました。"
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "shared/flash_message_turbo")
          ]
        end
        format.html { redirect_to seichi_memo_path(@seichi_memo), flash: { comment_alert: "コメントの編集に失敗しました。" } }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
