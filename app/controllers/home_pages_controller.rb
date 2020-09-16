class HomePagesController < ApplicationController
  def home
    #新着の質問を１００件だけ取得して表示する
    @questions = Question.limit(30).page(params[:page]).per(30)
  end

  def help

  end
end
