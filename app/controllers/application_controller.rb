class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  def logged_in_user # ログインしてなかったらログインさせる
    unless logged_in?
      store_location
      flash[:danger] = 'ログインしてください'
      redirect_to login_url
    end
  end
end
