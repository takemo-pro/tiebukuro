require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:take)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title("#{@user.name}さん")
    # assert_select 'h3', text: @user.name
    # assert_select 'h3>img.gravatar'
    assert_match @user.questions.count.to_s, response.body
    assert_select 'ul.pagination'
    @user.questions.page(1).each do |question|
      assert_match question.content, response.body
    end
  end
end
