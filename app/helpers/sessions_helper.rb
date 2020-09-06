module SessionsHelper
  def log_in(user) # ログイン処理
    session[:user_id] = user.id
  end

  def current_user # 現在ログインしているユーザーを返す cookiesにユーザーが保存されていればログイン処理を行う。
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user &. authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user # userとcurrent_userがnilでもnilを返す
  end

  def logged_in? # ログインしているときtrueを返す
    !current_user.nil?
  end

  def log_out # ログアウト処理
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user) # cookiesでユーザーを記憶しておく。
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default) # デフォ値か記憶していたURLにリダイレクト
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
