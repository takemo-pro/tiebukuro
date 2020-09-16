class QuestionsController < ApplicationController
  before_action :logged_in_user, only:[:new,:create,:edit,:update,:destroy] #show/index以外（閲覧以外）はログイン強制
  before_action :correct_user, only: :destroy
  def new
    @user = current_user
    @question = current_user.questions.build if logged_in?
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = "質問を投稿しました！"
      redirect_to @question.user
    else
      render 'new'
    end

  end

  def edit

  end

  def update

  end

  def show

  end

  def index
    redirect_to new_question_url
  end

  def destroy
    @question.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to request.referrer || root_url
  end

  private
    def question_params
      params.require(:question).permit(:content,:image)
    end

    def correct_user
      @question = current_user.questions.find_by(id: params[:id])
      redirect_to root_url if @question.nil?
    end
end
