require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @comment = comments(:one)
    @user = users(:take)
    @question = questions(:red)
  end

  test "create should redirect when not logged in" do
    assert_no_difference 'Comment.count' do
      post question_comments_path(@question), params:{comment:{content:"hogehoge",}}
    end
    assert_not flash.nil?
    assert_redirected_to login_url
  end

  test "destroy should redirect when not logged in" do
    assert_no_difference "Comment.count" do
      delete question_comment_path(@question,@comment)
    end
    assert_not flash.nil?
    assert_redirected_to login_url
  end

  test "destroy should redirect when logged in wrong user" do
    log_in_as(users(:edward)) #投稿者でないユーザーでログイン
    assert_no_difference "Comment.count" do
      delete question_comment_path(@question,@comment)
    end
    assert_redirected_to root_url
  end


end
