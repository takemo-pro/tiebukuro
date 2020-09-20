require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:take)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title("#{@user.name}さん")
    assert_select 'img.gravatar'
    assert_select 'span.content'
  end
end
