class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  # ログイン
  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:info] = 'ログインしました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレス/パスワードの組み合わせが無効です。'
      render :new
    end
  end

  # ログアウト
  def destroy
    reset_session
    flash[:info] = 'ログアウトしました。'
    redirect_to root_url
  end

  private

  def session_params
    params.required(:session).permit(:email, :password)
  end
end
