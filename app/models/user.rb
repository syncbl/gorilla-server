class User < ApplicationRecord
  include Blockable
  include Permissable
  include Notifiable
  include JwtTokenable
  include IdentityCache
  extend Enumerize

  # Include default devise modules. Others available are:
  # :rememberable, :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :timeoutable,
         :validatable

  enumerize :plan, in: %i[personal pro business unlimited], scope: true
  has_secure_token :authentication_token
  attribute :token
  translates :disclaimer

  # TODO: encrypts :email, deterministic: true, downcase: true

  has_many :packages, dependent: :destroy
  has_many :endpoints, dependent: :destroy
  has_many :subscriptions, dependent: :nullify
  has_many :notifications, as: :recipient

  validates :email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
            },
            uniqueness: {
              case_sensitive: false,
            },
            presence: true
  validates :name,
            name_restrict: true,
            presence: true,
            length: {
              minimum: MIN_NAME_LENGTH,
              maximum: MAX_NAME_LENGTH,
            },
            uniqueness: {
              case_sensitive: false,
            },
            format: {
              with: NAME_FORMAT,
            }
  validates :fullname, length: { maximum: MAX_NAME_LENGTH }
  validates :authentication_token,
            allow_nil: true, # To allow token auto generation
            length: {
              is: 24,
            }

  before_validation :generate_name

  def active_for_authentication?
    super && !blocked?
  end

  def authenticatable_salt
    "#{super}#{authentication_token}"
  end

  def inactive_message
    blocked? ? :blocked : super
  end

  def used_space
    packages.without_package_type(:external).map(&:size).sum
  end

  private

  def generate_name
    if name.blank?
      name = "#{email[/^[^@]+/]}"
      self.name =
        User.find_by(name: name).nil? ? name : "#{name}#{rand(10_000)}"
    end
    self.name.downcase!
  end
end
