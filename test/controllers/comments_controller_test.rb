require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @comment = comments(:one)
    @user = users(:take)
    @other_user = users(:edward)
    @other_user2 = users(:alphonse)
    @question = questions(:red)
  end

  test "create should redirect when not logged in" do
    assert_no_difference 'Comment.count' do
      post question_comments_path(@question), params:{comment:{content:"hogehoge",}}
    end
    assert_not flash.nil?
    assert_redirected_to login_url
  end

  test "create should redirect when invalid params" do
    log_in_as(@user)
    assert_no_difference 'Comment.count' do
      post question_comments_path(@question), params:{comment:{content:"",question_id:@question.id}}
    end
    assert_not flash.nil?
    assert_redirected_to @question
  end

  test "create should redirect when not correct user" do
    log_in_as(@other_user)
    #コメントを送信
    assert_difference 'Comment.count', 1 do
      post question_comments_path(@question), params:{comment:{content:"hogehoge",question_id:@question.id}}
    end
    new_comment = assigns(:comment)
    assert_not flash.nil?
    assert_redirected_to @question
    log_in_as(@other_user2)

    #上で送信したコメントを親にコメントを送信
    assert_no_difference 'Comment.count' do
      post question_comments_path(@question), params:{comment:{content:"hogehoge",question_id:@question.id,parent_id:new_comment.id}}
    end
    assert_redirected_to root_url
  end

  test "destroy should redirect when not logged in" do
    assert_no_difference "Comment.count" do
      delete question_comment_path(@question,@comment)
    end
    assert_not flash.nil?
    assert_redirected_to login_url
  end

  test "destroy should redirect when logged in wrong user" do
    log_in_as(@other_user) #投稿者でないユーザーでログイン
    assert_no_difference "Comment.count" do
      delete question_comment_path(@question,@comment)
    end
    assert_redirected_to root_url
  end


end
