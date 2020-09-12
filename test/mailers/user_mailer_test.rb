require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = users(:take)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'Account activation', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@grandmatch.net'], mail.from
    # 本文に日本語を含むため、html_partとtext_partにわけてテストする
    # （bodyだとASCIIにエンコードされてマッチしない)
    assert_match user.name, mail.html_part.body.encoded
    assert_match user.name, mail.text_part.body.encoded
    assert_match user.activation_token,  mail.html_part.body.encoded
    assert_match user.activation_token,  mail.text_part.body.encoded
    assert_match CGI.escape(user.email),  mail.html_part.body.encoded
    assert_match CGI.escape(user.email),  mail.text_part.body.encoded
  end

  test 'password_reset' do
    user = users(:take)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'Account Password reset', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@grandmatch.net'], mail.from
    assert_match user.reset_token, mail.html_part.body.encoded
    assert_match user.reset_token, mail.text_part.body.encoded
    assert_match CGI.escape(user.email), mail.html_part.body.encoded
    assert_match CGI.escape(user.email), mail.text_part.body.encoded
  end
end
