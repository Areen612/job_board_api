class User < ApplicationRecord
  has_secure_password
  has_many :job_posts
  has_many :job_applications

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  def admin?
    role == 'admin'
  end

  def job_seeker?
    role == 'jobseeker'
  end

  # JWT authentication
  def generate_jwt
    JWT.encode({ user_id: id, role: role }, Rails.application.secrets.secret_key_base)
  end

  def self.decode_jwt(token)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    find(decoded['user_id'])
  end
end


