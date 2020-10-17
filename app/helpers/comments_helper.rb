module CommentsHelper
  #返信がついていなくてレス相手であれば返せる
  def correct_comment_user?(comment_parent) #コメント可能なユーザーか返す
    if (current_user.id == (comment_parent.reply_user_id)) || (current_user == comment_parent.question.user)
      #返信先に誰も返信してないかつ解決してなければ返信できる
      if comment_parent.replies.empty? && !comment_parent.solved?
        return true
      else
        return false
      end
    else
      return false
    end
  end


end
