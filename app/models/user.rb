class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :downcase_email
  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.max_length_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.min_length_password}, allow_nil: true

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST:
    BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def self.get_all_user params
    User.select(:id, :name, :email).paginate(page: params[:page])
      .limit(Settings.users_per_page).select(:email).order "name ASC"
  end

  def downcase_email
    email.downcase!
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new remember_digest.is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def downcase_email
    email.downcase!
  end

end
