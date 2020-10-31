require 'test_helper'

class TagInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:take)
  end

  test "tag interface test" do
    log_in_as(@user)
    tags = ["hoge","foo","bar"]
    assert_difference 'Question.count', 1 do
      post questions_path, params:{question:{title:"hogehoge",
                                             tag_list:tags.join(","),
                                             content:"hogehogehogehoge"}}
    end
    post_question = assigns(:question)
    assert_redirected_to user_url(@user)
    tags.each do |tag|
      get search_questions_path(tag_name: tag)
      assert_select 'p.lead', text: post_question.title, count:1
    end
  end
end
