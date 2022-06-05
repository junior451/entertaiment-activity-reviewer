class User < ApplicationRecord
  has_secure_password

  has_many :movies

  validates :password_digest, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: 'Invalid email'  }
end