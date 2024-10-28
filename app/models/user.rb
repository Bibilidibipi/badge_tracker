class User < ApplicationRecord
  has_secure_password
  has_many :badge_users, dependent: :destroy
  has_many :badges, through: :badge_users
  validates :name, :session_token, presence: true, uniqueness: true
  validates :admin, inclusion: [ true, false ]
  after_initialize :set_defaults
  before_validation :ensure_session_token

  def reset_token!
    self.session_token = generate_session_token
    self.save!

    self.session_token
  end

  def earned_badges
    badges.joins(:badge_users).where('badge_users.earned = true').distinct
  end

  def eligible_badges
    badges.joins(:badge_users).where('badge_users.eligible = true').where('badge_users.earned = false').distinct
  end

  private

  def generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def set_defaults
    self.admin ||= false
  end
end
