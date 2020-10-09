module NoticesHelper
  def get_notice_sentence(notice)
    action = notice.action
    visiter_user = notice.visiter

    case action
      when "follow" then
        tag.a(visiter_user.name, href:user_path(visiter_user), style:"font-weight: bold;")+"があなたをフォローしました"
      when "like" then
        tag.a(visiter_user.name, href:user_path(visiter_user), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:question_path(notice.question), style:"font-weight: bold;")+"にいいねしました"
      when "comment" then
        tag.a(visiter_user.name, href:user_path(visiter_user), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:question_path(notice.question), style:"font-weight: bold;")+"にコメントしました"
    end
  end
end