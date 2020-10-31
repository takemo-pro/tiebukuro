class QuestionsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy,:solved]
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

  def show
    @question = Question.find(params[:id]) #質問のデータ
    @like = @question.likes.build
    @comments = @question.comments.where(parent: nil) #質問についたコメント(親)
    @new_comment = @question.comments.build
  end

  def destroy
    @question.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to  root_url
  end

  def search
    if params[:tag_name].nil?
      if params[:search][:text].empty?
        redirect_to root_url
        return
      end
       @questions = Question.search(params[:search][:text]).page(params[:page]).per(10)
      if @questions.empty?
        flash.now[:info] = "質問が見つかりませんでした"
      end
    else
      @questions = Question.tagged_with(params[:tag_name]).page(params[:page]).per(10)
    end
  end

  private
    def question_params
      params.require(:question).permit(:title,:content,:tag_list)
    end

    def search_params
      params.fetch()
    end
    def correct_user
      @question = current_user.questions.find_by(id: params[:id])
      redirect_to root_url if @question.nil?
    end
end
