class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_mail
      flash[:info] = '登録されたメールアドレスに認証メールを送信しました。'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    @users = User.where(activated:true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました'
      redirect_to @user
    elsif render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'ユーザーを削除しました'
    redirect_to users_path
  end

  private

  def user_params # StrongParameter(user)
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user # ログインしてなかったらログインさせる
    unless logged_in?
      store_location
      flash[:danger] = 'ログインしてください'
      redirect_to login_url
    end
  end

  def correct_user # 対象外のユーザーはリダイレクトで排除する
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user # 管理者でないユーザーはルートにリダイレクトさせる
    redirect_to(root_url) unless current_user.admin?
  end
end
