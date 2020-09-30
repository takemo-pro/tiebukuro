class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy
  before_action :question_user, only: :solved

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

  def solved #お礼コメを作成しフラグを変更する
    @comment.solved=true
    if @comment.save
      #親コメがあれば親コメもsolved: trueを指定
      while @comment.parent do
        @comment.parent.update(solved: true)
        if @comment.parent
          @comment = @comment.parent
        else
          @comment = nil
        end
      end

      # 親コメ全てフラグ変えた後は元の質問の解決フラグをtrueにする
      @comment.question.update(solved: true)
      flash[:success] = "解決しました！"
      #リダイレクトで元質問のshowページへ
      redirect_to @comment.question

    elsif @comment.content==nil
      @comment.parent.update(solved:true)
      flash[:success] = "解決しました！"
      redirect_to @comment.question

    else
      @comment.solved = false
      flash[:danger] = "コメントの送信に失敗しました"
      redirect_to root_url
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
      if @comment.nil?
        redirect_to root_url
      end
    end

    def question_user #正しいユーザーで解決済みにしようとしているか確認
      @comment = current_user.comments.build(comment_params)
      unless @comment.question.user == current_user
        redirect_to root_url
      end
    end


end
