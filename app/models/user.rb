class User < ApplicationRecord
  include Discard::Model

  # Include default devise modules. Others available are:
  # :validatable, :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :timeoutable, :lockable

  has_secure_token :authentication_token

  # Because of company support and installed packages we can't allow to delete resources
  # has_many (as on Git) OR belongs_to :group, optional: true
  has_many :packages, dependent: :nullify
  has_many :endpoints, dependent: :nullify

  after_discard do
    # if group.nil?
    endpoints.discard_all
    packages.discard_all
  end

  validates :email, presence: true, length: { maximum: MAX_EMAIL_LENGTH },
    uniqueness: { case_sensitive: false },
    format: { with: EMAIL_FORMAT }
  validates :username, length: { maximum: MAX_NAME_LENGTH },
    uniqueness: { case_sensitive: false }, allow_blank: true, exclusion: { in: NAME_EXCLUSIONS },
    name_restrict: true, format: { with: NAME_FORMAT }

  attr_accessor :endpoint

  # TODO: Everyone can create packages, but we need to add permissions for company members later

  def readable_name
    name || email
  end

  def block!(reason = nil)
    self.discarded_at = Time.current
    self.discard_reason = reason
    save!
  end

end
