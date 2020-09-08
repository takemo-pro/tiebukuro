class User < ApplicationRecord
  before_save :downcase_email
  before_create :create_activation_digest
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
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

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def create_activation_digest # アクティベーションのトークンとダイジェストを生成、保存する
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email # メールアドレスをDB保存前に全て小文字化する（データの統一・唯一性の保持）
    email.downcase!
  end
end
