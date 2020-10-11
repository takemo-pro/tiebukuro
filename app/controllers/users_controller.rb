class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy,:followed,:follower]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :check_test_user, only: :update
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_new_params)
    if @user.save
      @user.send_activation_mail
      flash[:info] = '登録されたメールアドレスに認証メールを送信しました。'
      redirect_to root_url
    else
      render 'new'
    end
  end


  def followed #フォローしているユーザー一覧を返す
    @following_users = current_user.following.page(params[:page]).per(20)
  end

  def follower #フォロワー一覧を返す
    @follower_users = current_user.followers.page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    #ユーザーの投稿した質問一覧をフィードする
    @questions = @user.questions.page(params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_edit_params)
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

  def user_new_params # StrongParameter(user)
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_edit_params
    params.require(:user).permit(:name,:profile,:user_icon)
  end

  def correct_user # 対象外のユーザーはリダイレクトで排除する
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user # 管理者でないユーザーはルートにリダイレクトさせる
    redirect_to(root_url) unless current_user.admin?
  end

  def check_test_user #テストユーザーのアカウントは編集できないようにする
    @user = User.find(params[:id])
    if @user.email == "admin.grandmatch@gmail.com"
      flash[:danger] = "テスト用アカウントのためユーザー情報は変更できません"
      redirect_to root_url
    end
  end
end
