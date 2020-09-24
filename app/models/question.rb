class Question < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length:{maximum: 2000}
  validates :title, presence: true, length:{maximum: 40}
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png image/tiff image/heic],
                                      message: "ではないか、無効なファイルです" },
                      size:         { less_than: 8.megabytes,
                                      message: "が大きすぎます（8MB以下にしてください）" }

  def display_image #リサイズした画像を返す
    image.variant(resize_to_limit: [500,500])
  end

end