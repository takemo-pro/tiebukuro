class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only:[:update,:destroy]
  before_action :question_user, only: :solved
  before_action :comment_user, only: :create

  def create
    if @comment.save
      @comment.create_comment_notice_by(current_user)
      #とりあえずajaxは使わずリダイレクトで画面を更新する。
      flash[:success] = "コメントを送信しました！"
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

  def update

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

    def comment_user #コメントを送るユーザーが正しいか確認
      @comment = current_user.comments.build(comment_params)

      #解決済みの質問にはコメントをつけない
      if @comment.question.solved?
        redirect_to root_url
      else
        @comment.set_reply_user_id
        #コメ主が質問主と同じorコメ主が設定されていないor正しいコメ主
        unless @comment.reply_user?
          redirect_to root_url
        end
      end
    end


end
