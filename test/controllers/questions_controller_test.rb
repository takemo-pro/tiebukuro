require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @question = questions(:red)
  end

  test "should redirect new when not logged in" do
    get new_question_path
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Question.count' do
      post questions_path, params:{question:{content: "hogehoge"}}
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Question.count' do
      delete question_path(@question)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when wrong user" do
    log_in_as(users(:take))
    question = questions(:non_take)
    assert_no_difference 'Question.count' do
      delete question_path(question)
    end
    assert_redirected_to root_url
  end
end
