class Endpoint < ApplicationRecord
  include Blockable
  include Notifiable
  include JwtTokenable
  include IdentityCache

  has_secure_token :authentication_token

  # attribute :locale, :string, default: "en"
  attribute :token

  belongs_to :user, optional: true
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings
  has_many :notifications, as: :recipient, dependent: :destroy

  validates :caption, length: { maximum: MAX_NAME_LENGTH }
  validates :locale, length: { maximum: 10 }
  validates :authentication_token,
            allow_nil: true, length: { is: 24 }

  def installed?(package)
    settings.exists?(package:)
  end

  def actualized_settings(packages, timestamp)
    actual_settings = ActualizedSettingsService.call(self, packages, timestamp)
    settings.where(consistent: false).update(consistent: true)
    actual_settings
  end
end
