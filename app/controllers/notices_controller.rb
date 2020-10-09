class NoticesController < ApplicationController
  before_action :logged_in_user
  before_action :destroy_old_notices
  def index
    #通知ページにアクセスしたら既読にする
    @notices.update_all(checked:true)
  end

  def destroy_old_notices #既読後3ヶ月経った通知があれば消す
    old_notices = current_user.passive_notices.where("created_at < ? and checked = ?",3.month.ago,true)
    old_notices.destroy_all
    @notices = current_user.passive_notices.reload.page(params[:page]).per(15)
  end
end
