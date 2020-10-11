require 'test_helper'

class FeedsOrderTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:take)
  end

  test "Question feed order test" do
    log_in_as(@user)
    get root_path
    #新規登録順に質問が並んでいるか確認
    questions = assigns(:questions)
    time = Time.zone.now
    questions.each do |question|
      assert question.updated_at <= time
      time = question.updated_at
    end
    #フォローしているユーザーの投稿だけあるか確認
    get root_path(sort: "follow")
    questions = assigns(:questions)
    questions.each do |question|
      assert @user.following.include?(question.user)
    end
    #いいね順に質問が並んでいるか確認
    get root_path(sort: "likes")
    questions = assigns(:questions)
    max = questions.first.liked_users.count
    questions.each do |question|
      assert question.liked_users.count <= max
      max = question.liked_users.count
    end
    #未解決質問だけ並んでいるか確認
    get root_path(sort: "nonsolved")
    questions = assigns(:questions)
    questions.each do |question|
      assert_not question.solved?
    end
  end
end
