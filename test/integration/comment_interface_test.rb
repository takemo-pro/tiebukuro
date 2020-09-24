require 'test_helper'

class CommentInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @question = questions(:red)
    @user = users(:take)
    @parent_comment = comments(:one)
    @other_user = users(:edward)
  end

  test 'question interface test' do
    #ログインしてshowページにアクセス
    log_in_as(@user)
    get question_path(@question)
    assert_template 'questions/show'
    #showページ内に正しい要素が配置されているか
    assert_select 'nav.sidebar'
    assert_select 'h5.lead'
    assert_match @question.content, response.body
    assert_select 'form'
    #新規コメントを送信してみる
    content = "hogehoge"
    image = fixture_file_upload('test/fixtures/sample_image.jpeg','image/jpeg')
    assert_difference 'Comment.count', 1 do
      post question_comments_path(@question), params:{comment:{content:content,
                                                               image:image,
                                                               question_id:@question.id}}
    end
    #リダイレクトでquestion#showに戻る
    assert_redirected_to question_url(@question)
    follow_redirect!
    #コメントが追加されているか確認
    assert_match content, response.body
    # ️コメントの親子関係が作られるかチェック
    post question_comments_path(@question), params:{comment:{content:content,
                                                             image:image,
                                                             question_id:@question.id,
                                                             parent_id:@parent_comment.id}}
    new_comment = assigns(:comment)
    # アソシエーションが組まれているか両方からチェック
    assert new_comment.parent_id == @parent_comment.id
    assert @parent_comment.replies.include?(new_comment)
  end
end