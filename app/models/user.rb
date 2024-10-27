class User < ApplicationRecord
  has_secure_password
  validates :name, :session_token, presence: true, uniqueness: true
  validates :admin, inclusion: [ true, false ]
  after_initialize :set_defaults
  before_validation :ensure_session_token

  def reset_token!
    self.session_token = generate_session_token
    self.save!

    self.session_token
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
