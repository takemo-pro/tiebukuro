class HomePagesController < ApplicationController
  def home
    case params[:sort]
    when "likes"
      #いいねじゅんに入れ替えて１００個表示
      questions_part= Question.left_outer_joins(:likes).group('questions.id').select('questions.*, COUNT(likes.*) AS likes_count').distinct.reorder(likes_count: :desc).limit(100)




    when "follow"
      #followしているユーザーの質問で1０0件取得
      current_user_id = current_user.id
      following_ids = "SELECT followed_id FROM relationships WHERE follower_id = #{current_user_id}"
      questions_part = Question.where("user_id IN (#{following_ids})").limit(100)
    when "nonsolved"
      #solved::falseの質問を新しい順に１００件
      questions_part = Question.order(updated_at: :desc).where(solved: :false).limit(100)
    else
      #新着の質問150を取得して表示
      questions_part = Question.order(updated_at: :desc).limit(100)
    end

    question_array = questions_part.each_with_object [] do |question, result|
      result << question
    end
    @questions = Kaminari.paginate_array(question_array).page(params[:page]).per(20)
  end

  def help

  end
end
