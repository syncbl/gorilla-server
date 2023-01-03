class User < ApplicationRecord
  include IdentityCache
  include Blockable
  include Notifiable
  include TokenResetable
  extend Enumerize

  # :rememberable, :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :timeoutable,
         :validatable

  enumerize :plan, in: %i[personal pro business unlimited], scope: true

  # TODO: encrypts :email, deterministic: true, downcase: true

  has_many :packages, dependent: :destroy
  has_many :endpoints, dependent: :destroy
  has_many :plans, dependent: :nullify
  # TODO: Noticed has_many :notifications, as: :recipient, dependent: :destroy

  validates :email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            },
            uniqueness: {
              case_sensitive: false
            },
            presence: true
  validates :name,
            name_restrict: true,
            presence: true,
            length: {
              minimum: MIN_NAME_LENGTH,
              maximum: MAX_NAME_LENGTH
            },
            uniqueness: {
              case_sensitive: false
            },
            format: {
              with: NAME_FORMAT
            }
  validates :fullname,
            length: {
              maximum: MAX_NAME_LENGTH
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
    packages.sum(&:size)
  end

  private

  def generate_name
    if name.blank?
      name = email[/^[^@]+/].to_s
      self.name =
        User.find_by(name: name).nil? ? name : "#{name}#{rand(10_000)}"
    end
    self.name.downcase!
  end
end
