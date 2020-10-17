class Question < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notices, dependent: :destroy
  has_one_attached :image
  has_rich_text :content
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 10000}
  validates :title, presence: true, length:{maximum: 40}
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png image/tiff image/heic],
                                      message: "ではないか、無効なファイルです" },
                      size:         { less_than: 8.megabytes,
                                      message: "が大きすぎます（8MB以下にしてください）" }

  def display_image #リサイズした画像を返す
    image.variant(resize_to_limit: [500,500])
  end

  def create_like_notice_by(current_user) #いいねの通知を質問主に送る
    notice = current_user.active_notices.build(
      question_id: self.id,
      visited_id: self.user_id,
      action: "like"
    )
    #自分の投稿に自分がいいねする時以外は通知を送る
    notice.save unless current_user == self.user
  end

  def self.search(search) #search文字列を検索して返す
    return nil unless search
    Question.where(['title LIKE ?', "%#{search}%"])
  end

end
