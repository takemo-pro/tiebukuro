require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:take)
  end

  test 'password resets' do
    #newページが描画され、メールアドレスのフォームがある
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    #無効なアドレスを送信する
    post password_resets_path , params:{password_reset:{email:''}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #有効なアドレスを送信する
    post password_resets_path , params:{password_reset:{email:@user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_not flash.empty?
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_url
    #パスワード再設定フォーム
    user = assigns(:user)
    #アクティベートしてないユーザーでアクセス
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token,email:user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #メールアドレスが無効な場合
    get edit_password_reset_path(user.reset_token,email:"")
    assert_redirected_to root_url
    #トークンが無効な場合
    get edit_password_reset_path('invalid token',email:user.email)
    assert_redirected_to root_url
    #メールアドレス・トークンともに有効な場合
    get edit_password_reset_path(user.reset_token,email:user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=?]', 'user[password]'
    assert_select 'input[name=?]', 'user[password_confirmation]'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    #無効なパスワード・パスワード確認の組み合わせ
    patch password_reset_path, params:{email:user.email,user:{password:"fooooo",password_confirmation:"barrrr"}}
    assert_template 'password_resets/edit'
    assert_select 'div#errors_explanation'
    #パスワードが空
    patch password_reset_path, params:{email:user.email,user:{password:"",password_confirmation:""}}
    assert_template 'password_resets/edit'
    assert_select 'div#errors_explanation'
    #有効なパスワードの組み合わせ
    patch password_reset_path, params:{email:user.email,user:{password:"fooobarr",
                                                              password_confirmation:"fooobarr"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
