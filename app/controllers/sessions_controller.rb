class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      flash[:success] = 'ログインしました'
      redirect_to user
    else
      #フラッシュエラーメッセージを表示、newを描画
      flash.now[:danger] = 'メールアドレスかパスワードが正しくありません。'
      render 'new'
    end
  end


  def destroy
    #セッションと一時ユーザー変数を消してルートへ
    log_out
    redirect_to root_url
  end

end
