class User < ApplicationRecord
  include ModelBlocker

  before_create :set_username

  # Include default devise modules. Others available are:
  # :validatable, :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :timeoutable, :lockable

  has_secure_token :authentication_token

  # Because of company support and installed packages we can't allow to delete resources
  # has_many (as on Git) OR belongs_to :group, optional: true
  has_many :packages, dependent: :destroy # TODO: :nullify
  has_many :endpoints, dependent: :destroy

  validates :email,
    presence: true,
    length: { maximum: MAX_EMAIL_LENGTH },
    uniqueness: { case_sensitive: false },
    format: { with: EMAIL_FORMAT }
  validates :username,
    presence: true,
    length: { maximum: MAX_NAME_LENGTH },
    uniqueness: { case_sensitive: false },
    exclusion: { in: NAME_EXCLUSIONS },
    format: { with: NAME_FORMAT }

  attr_accessor :endpoint

  # TODO: Everyone can create packages, but we need to add permissions for company members later

  def set_username
    self.username = "#{self.email[/^[^@]+/]}#{rand(10000)}" if self.username.nil?
  end

end
