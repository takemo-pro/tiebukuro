class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      flash[:success] = 'ログインしました'
      redirect_back_or @user
    else
      # フラッシュエラーメッセージを表示、newを描画
      flash.now[:danger] = 'メールアドレスかパスワードが正しくありません。'
      render 'new'
    end
  end

  def destroy
    # セッションと一時ユーザー変数を消してルートへ
    log_out if logged_in?
    redirect_to root_url
  end
end
