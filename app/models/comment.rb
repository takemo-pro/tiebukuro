class Comment < ApplicationRecord
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
  def display_image
    image.variant(resize_to_limit: [500,500])
  end
end
