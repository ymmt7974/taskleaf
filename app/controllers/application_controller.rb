class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required

  private

  # ログインユーザを返却
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ログイン済みチェック
  def login_required
    redirect_to login_url unless current_user
  end

end
