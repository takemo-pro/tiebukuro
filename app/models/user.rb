class User < ApplicationRecord
  has_many :questions, dependent: :destroy #質問の関連性
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  has_many :active_notices, class_name: "Notice",
                            foreign_key: "visiter_id",
                            dependent: :destroy
  has_many :passive_notices, class_name: "Notice",
                             foreign_key: "visited_id",
                             dependent: :destroy

  before_save :downcase_email
  before_create :create_activation_digest
  default_scope -> {order(created_at: :asc)}
  has_one_attached :user_icon

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :profile, length:{maximum: 500}
  validates :user_icon,   content_type: { in: %w[image/jpeg image/gif image/png image/tiff image/heic],
                                      message: "ではないか、無効なファイルです" },
                      size:         { less_than: 5.megabytes,
                                      message: "が大きすぎます（5MB以下にしてください）" }
  has_secure_password
  attr_accessor :remember_token, :activation_token , :reset_token

  def self.digest(string) #指定された文字列をBCryptでハッシュ化して返す。
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token #base64でランダムなトークンを生成する。
    SecureRandom.urlsafe_base64
  end

  def remember #記憶トークンの生成・ダイジェストの保存
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token) # トークンが正しいか認証する
    digest = send("#{attribute}_digest")
    return false if digest.nil? # ダイジェストがないときにはfalse（複数ブラウザ対策）

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget #記憶ダイジェストの削除
    update_attribute(:remember_digest, nil)
  end

  def activate # ユーザーを有効化する
    update_columns(activated:true,activated_at:Time.zone.now)
  end

  def send_activation_mail # 有効化メールを送信する
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest #リセットトークンの生成・ダイジェストの保存・生成時刻の保存
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email #パスワードリセットメールを送信する。
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired? #パスワードリセットの有効期間内かどうか返す。
    reset_sent_at < 2.hours.ago
  end

  def resize_icon(size:50) #ユーザーアイコンのリサイズ
    user_icon.variant(resize_to_fill: [size,size])
  end

  def already_liked?(question) #ビューで質問に対していいねをすでにしているかどうか返す
    self.likes.exists?(question_id: question.id)
  end

  def follow(other_user) #ユーザーをフォローする
    self.following << other_user
    create_follow_notice(other_user) #フォロー通知の作成
  end

  def unfollow(other_user) #ユーザーのフォローを解除する
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user) #特定のユーザーをフォローしているかどうか返す
    self.following.include?(other_user)
  end



  private

  def create_activation_digest # アクティベーションのトークンとダイジェストを生成、保存する
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email # メールアドレスをDB保存前に全て小文字化する（データの統一・唯一性の保持）
    email.downcase!
  end

  def create_follow_notice(followed_user) #フォロー通知をおくる

    notice = self.active_notices.create(
      visited_id: followed_user.id,
      action: "follow"
    )
  end
end
