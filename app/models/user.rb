class User < ApplicationRecord
  include Blockable

  # Include default devise modules. Others available are:
  # :validatable, :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :timeoutable,
         :lockable

  has_secure_token :authentication_token
  # ??? attribute :authentication_token, :string, default: SecureRandom.urlsafe_base64(nil, false)
  attribute :locale, :string, default: "en"

  attr_accessor :endpoint

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
            name_restrict: true,
            presence: true,
            length: { minimum: MIN_NAME_LENGTH, maximum: MAX_USERNAME_LENGTH },
            uniqueness: { case_sensitive: false },
            format: { with: NAME_FORMAT }
  validates :name,
            length: { maximum: MAX_NAME_LENGTH }
  validates :locale,
            length: { maximum: 10 }
  validates :authentication_token,
            allow_nil: true, # To allow token auto generation
            length: { is: 24 }

  # TODO: Everyone can create packages, but we need to add permissions for company members later

  def generate_username
    username = "#{self.email[/^[^@]+/]}"
    self.username = User.find_by(username: username).nil? ? username : "#{username}#{rand(10_000)}"
  end

  def active_for_authentication?
    super && !self.blocked?
  end

  def authenticatable_salt
    "#{super}#{authentication_token}"
  end

  def inactive_message
    !self.blocked? ? super : :blocked
  end
end
