require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:take)
    @other_user = users(:edward)
    @question = questions(:red)
  end

  test "like should be one-on-one with users and questions" do
    log_in_as(@user)
    assert_difference 'Like.count',1 do
      post question_likes_path(@question)
    end
    assert_redirected_to @question
    assert_no_difference 'Like.count' do
      post question_likes_path(@question)
    end
    assert_redirected_to root_url
  end

  test "should create like with ajax" do
    log_in_as(@user)
    assert_difference 'Like.count',1 do
      post question_likes_path(@question), xhr:true
    end
  end

  test "should create like destroy with ajax" do
    log_in_as(@user)
    post question_likes_path(@question)
    like = assigns(:like)
    assert_difference 'Like.count', -1 do
      delete question_like_path(@question,like), xhr:true
    end
  end
end
