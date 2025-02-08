# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # サインアップ時に許可するパラメータを追加
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
  end

  protected

  # ユーザー登録後のリダイレクト先を変更
  def after_sign_up_path_for(resource)
    seichi_memos_path # 聖地メモ一覧ページにリダイレクト
  end

  # ユーザー登録後（メール認証などで未アクティブ時）のリダイレクト先
  def after_inactive_sign_up_path_for(resource)
    seichi_memos_path # 聖地メモ一覧ページにリダイレクト
  end
end
