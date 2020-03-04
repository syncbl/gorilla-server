class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :timeoutable, :lockable

  # Because of company support and installed packages we can't allow to delete resources
  belongs_to :company, optional: true
  has_many :packages, dependent: :nullify
  has_many :endpoints, dependent: :nullify

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  attr_accessor :endpoint_key
  attr_accessor :endpoint_token
  attr_accessor :token_changed
  # TODO: Everyone can create packages, but we need to add permissions for company members later

  def readable_name
    name || email
  end

end
