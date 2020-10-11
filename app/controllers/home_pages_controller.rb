class HomePagesController < ApplicationController
  def home
    case params[:sort]
    when nil then
      #新着の質問150を取得して表示
      questions_part = Question.order(updated_at: :desc).limit(100)
    when "likes"
      #いいねじゅんに入れ替えて１００個表示
      liked_questions = Question.where(id: Like.group(:question_id).order("count(question_id) desc").limit(100).pluck(:question_id)).order(updated_at: :desc).limit(100)
      #いいねされてる投稿が１００件以下のときは新規順で投稿を付け足して１００件にする
      if liked_questions.count < 100
        add_questions = Question.order(updated_at: :desc).limit(100)
        questions_part = liked_questions.or(add_questions).limit(100)
      else
        questions_part = liked_questions
      end

    when "follow"
      #followしているユーザーの質問で1０0件取得
      current_user_id = current_user.id
      following_ids = "SELECT followed_id FROM relationships WHERE follower_id = #{current_user_id}"
      questions_part = Question.where("user_id IN (#{following_ids})").limit(100)
    when "nonsolved"
      #solved::falseの質問を新しい順に１００件
      questions_part = Question.order(updated_at: :desc).where(solved: :false).limit(100)
    end

    question_array = questions_part.each_with_object [] do |question, result|
      result << question
    end
    @questions = Kaminari.paginate_array(question_array).page(params[:page]).per(20)
  end

  def help

  end
end
