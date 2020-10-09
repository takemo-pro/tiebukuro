require 'test_helper'

class UserNoticeTest < ActionDispatch::IntegrationTest
  def setup
    @question = questions(:red)
    @visited_user = users(:take)
    @visiter_user = users(:alphonse)
  end
  test "notice interface test" do
    #いいねをされた時のテスト
    log_in_as(@visiter_user)
    assert_not @visited_user.passive_notices.find_by(action:"like")
    post question_likes_path(@question)
    assert @visited_user.passive_notices.find_by(action:"like")
    #コメントされた時のテスト
    assert_not @visited_user.passive_notices.find_by(action:"comment")
    post question_comments_path(@question), params:{comment:{content:"hogehoge",
                                                             question_id: @question.id}}
    assert @visited_user.passive_notices.find_by(action:"comment")
    #フォローされた時のテスト
    assert_not @visited_user.passive_notices.find_by(action:"follow")
    post relationships_path, params:{followed_id: @visited_user.id}
    assert @visited_user.passive_notices.find_by(action:"follow")
    #既読機能の検証
    log_in_as(@visited_user)
    assert_not @visited_user.passive_notices.find_by(checked:true)
    get notices_path
    assert @visited_user.passive_notices.find_by(checked:true)
  end
end
