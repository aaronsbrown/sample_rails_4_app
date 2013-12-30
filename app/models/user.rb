class User < ActiveRecord::Base

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	has_many :microposts

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: {with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 6 }

	has_secure_password

	before_create :create_remember_token
	before_save { email.downcase! }

	def self.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def self.encrypt(string)
		Digest::SHA1.hexdigest(string.to_s)
	end

	private 

	def create_remember_token
		self.remember_token = User.encrypt(User.new_remember_token)
	end

end
