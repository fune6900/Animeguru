# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # ログイン後のリダイレクト先を変更
  def after_sign_in_path_for(resource)
    seichi_memos_path # 聖地メモ一覧ページにリダイレクト
  end
end
