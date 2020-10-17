require 'test_helper'

class CommentInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @question = questions(:red)
    @user = users(:take)
    @parent_comment = comments(:one)
    @reply_comment = comments(:two)
    @other_user = users(:edward)
  end

  test 'comment interface test' do
    #ログインしてshowページにアクセス
    log_in_as(@user)
    get question_path(@question)
    assert_template 'questions/show'
    #showページ内に正しい要素が配置されているか
    assert_select 'nav.sidebar'
    assert_select 'h5.lead'
    assert_select 'form'
    #新規コメントを送信してみる
    content = "hogehoge"
    image = fixture_file_upload('test/fixtures/sample_image.jpeg','image/jpeg')
    assert_difference 'Comment.count', 1 do
      post question_comments_path(@question), params:{comment:{content:content,
                                                               question_id:@question.id}}
    end
    new_comment = assigns(:comment)
    #リダイレクトでquestion#showに戻る
    assert_redirected_to question_url(@question)
    follow_redirect!
    #コメントが追加されているか確認
    assert_match content, response.body
    # ️コメントの親子関係が作られるかチェック
    post question_comments_path(@question), params:{comment:{content:image,
                                                             question_id:@question.id,
                                                             parent_id:new_comment.id}}
    # アソシエーションが組まれているか両方からチェック
    new_comment2 = assigns(:comment)
    assert new_comment.reload.replies.include?(new_comment2)
    assert new_comment == new_comment2.reload.parent
  end

  test "comment solved test" do
    log_in_as(@user)
    post solved_question_comments_path(@question), params:{comment:{content:"hogehoge",question_id:@question.id,parent_id:@parent_comment.id}}
    #作成したコメントを取得
    new_comment = assigns(:comment)
    assert new_comment.solved?
    assert @parent_comment.reload.solved?
    assert @question.reload.solved?
    assert_redirected_to question_url(@question)
  end
end