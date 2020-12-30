class User < ApplicationRecord
  include Blockable

  before_create :set_username

  # Include default devise modules. Others available are:
  # :validatable, :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :timeoutable,
         :lockable

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
            name_restrict: true,
            presence: true,
            length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH },
            uniqueness: { case_sensitive: false },
            format: { with: NAME_FORMAT }

  attr_accessor :endpoint

  # TODO: Everyone can create packages, but we need to add permissions for company members later

  def set_username
    if username.nil? || (username.size < MIN_NAME_LENGTH)
      self.username = "#{self.email[/^[^@]+/]}#{rand(10_000)}"
    end
  end
end
