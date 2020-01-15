class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :timeoutable, :lockable
  has_secure_token :authentication_token

  has_many :packages, dependent: :destroy
  has_many :endpoints

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }
  validates :key, length: {is: 36}, allow_blank: true

  #default_scope -> {
  #  includes(:endpoints)
  #}

  def readable_name
    name || email
  end

end
