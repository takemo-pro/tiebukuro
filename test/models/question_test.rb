require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @user = users(:take)
    @question = @user.questions.build(content:"hogehoge",title:"hogehoge")
  end

  test "should be valid" do
    assert @question.valid?
  end

  test "user id should be present" do
    @question.user_id = nil
    assert_not @question.valid?
  end

  test "content should be present" do
    @question.content = nil
    assert_not @question.valid?
  end

  test "title should be present" do
    @question.title = nil
    assert_not @question.valid?
  end

  test "title should be less than 41 characters" do
    @question.title = 'a' * 41
    assert_not @question.valid?
  end

  test "content should be less than 2001 characters" do
    @question.content = "a" * 2001
    assert_not @question.valid?
  end

  test "order should be most recent first" do
    assert_equal questions(:most_recent), Question.first
  end
end
