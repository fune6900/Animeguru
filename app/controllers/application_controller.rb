class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :clear_seichi_memo_session, unless: :seichi_memo_controller_and_valid_action?

  private

  def clear_seichi_memo_session
    session.delete(:seichi_memo)
  end

  def seichi_memo_controller_and_valid_action?
    controller_name == "seichi_memos" && %w[edit update_session confirm create update].include?(action_name)
  end
end
