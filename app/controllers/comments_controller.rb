class CommentsController < ApplicationController
  before_action :logged_in_user, only:[:create,:destroy]
  before_action :correct_user
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      #とりあえずajaxは使わずリダイレクトで画面を更新する。
      redirect_to @comment.question
    else
      flash[:danger] = "コメントの送信に失敗しました"
      redirect_to @comment.question
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_to request.referrer || root_url
  end

  private
    def comment_params
      params.require(:comment).permit(:content,:image,:question_id,:user_id,:parent_id)
    end

    def correct_user
      @comment = current_user.comments.find_by(id:params[:id])
    end
end
