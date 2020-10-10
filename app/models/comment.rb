class Comment < ApplicationRecord
  default_scope -> {order(solved: :desc)}
  belongs_to :user
  belongs_to :question
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_one_attached :image

  validates :content, presence: true, length:{maximum: 1000}
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png image/tiff image/heic],
                                      message: "ではないか、無効なファイルです" },
                      size:         { less_than: 8.megabytes,
                                      message: "が大きすぎます（8MB以下にしてください）" }
  def display_image #コメント欄の画像のリサイズ
    image.variant(resize_to_limit: [500,500])
  end

  def set_reply_user_id #リプ可能なユーザーを設定する
    if self.parent.nil?
      #質問主の注釈コメは他のユーザーからリプできない
      self.reply_user_id = self.user_id
    else
      self.reply_user_id = self.parent.reply_user_id
    end
  end

  def reply_user? #リプ可能なユーザーかどうかかえす
    (self.reply_user_id==self.user_id) || (self.reply_user_id==self.question.user_id)
  end

  def create_comment_notice_by(current_user) #コメントの通知を作成する
    if self.parent_id.nil? #コメントへの返信か質問への返信かで通知の送信先を変える
      parent_user_id = self.question.user_id
    else
      parent_user_id = self.parent.user_id
    end
    notice = current_user.active_notices.build(
      question_id: self.question_id,
      comment_id: self.id,
      visited_id: parent_user_id,
      action:"comment"
    )
    notice.save unless current_user.id == parent_user_id #自分自身に送信する際は通知を作成しない
  end
end
