require 'test_helper'

class QuestionInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:take)
  end

  test "question interface" do
    log_in_as @user
    get new_question_path
    assert_template 'questions/new'
    post questions_path, params:{question:{content:''}} #無効な値の投稿
    assert_template 'questions/new' #エラーを吐いてnewページを再描画
    assert_not flash.nil?
    content="hogehoge"
    image = fixture_file_upload('test/fixtures/sample_image.jpeg','image/jpeg')
    assert_difference 'Question.count',1 do
      post questions_path, params:{question:{content:'hogehoge',image: image}}#有効な値の投稿
    end
    assert_redirected_to user_url(@user) #ユーザーshowページに飛ぶ
    assert assigns(:question).image.attached?
    follow_redirect!
    assert_match content, response.body #投稿したデータが描画されている
    assert_select 'a', text: "投稿を削除"
    sample_question = @user.questions.first #ユーザーの持つ最初の投稿を消してみる
    assert_difference 'Question.count', -1 do
      delete question_path(sample_question)
    end
    get user_path(users(:edward)) #別ユーザーのページではDeleteリンクが表示されない
    assert_select 'a', text:'投稿を削除', count:0

  end


end
