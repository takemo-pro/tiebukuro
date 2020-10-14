module CommentsHelper
  #返信がついていなくてレス相手であれば返せる
  def correct_comment_user?(comment_parent) #コメント可能なユーザーか返す
    if (current_user.id == (comment_parent.reply_user_id)) || (current_user == comment_parent.question.user)
      #返信先に誰も返信してなければ返信できる
      comment_parent.replies.empty?
      #解決済み質問にもコメできない
      if comment_parent.solved?
        return false
      end
    else
      return false
    end
  end
end
