class UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]

  def show
    @user = User.find(params[:id])
    @seichi_memos = @user.seichi_memos.includes(:anime, :genre_tags, :likes).order(created_at: :desc).page(params[:page]).per(6)
  rescue ActiveRecord::RecordNotFound
    redirect_to seichi_memos_path, alert: "ユーザーが見つかりません"
  end

  def profile
    @user = current_user
    @seichi_memos = @user.seichi_memos.includes(:anime, :genre_tags, :likes).order(created_at: :desc).page(params[:page]).per(6)
    render :show
  end
end
