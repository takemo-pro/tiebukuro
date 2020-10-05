class LikesController < ApplicationController
  before_action :logged_in_user
  before_action :set_question
  before_action :like_unique, only: :create

  def create
    @like = current_user.likes.create(question_id: params[:question_id])
    #あとでAjaxを実装するまでとりあえずルート
    respond_to do |format|
      format.html { redirect_to @like.question || root_url }
      format.js
    end

  end

  def destroy
    @like = @question.likes.find_by(user_id: current_user.id)
    @like.destroy
    #あとでAjaxを実装するまでとりあえずルート
    respond_to do |format|
      format.html { redirect_to @like.question || root_url}
      format.js
    end
  end

  private
  def set_question
    @question = Question.find(params[:question_id])
  end

  def like_unique #いいねしているのにいいねしようとしたらルートに飛ばす
    if current_user.already_liked?(@question)
      redirect_to root_url
    end
  end
end
