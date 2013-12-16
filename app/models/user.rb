class User < ActiveRecord::Base

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: {with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 6 }

	has_secure_password

	before_save { email.downcase! }

end
