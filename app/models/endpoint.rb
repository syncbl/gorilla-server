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

  validates :name,
            length: { maximum: MAX_NAME_LENGTH }
  validates :locale,
            length: { maximum: 10 }
  validates :authentication_token,
            allow_nil: true,
            length: { is: 24 }

  default_scope {
    includes(:user)
  }  

  def installed?(package)
    settings.exists?(package: package)
  end

  def install(package)
    settings.create(package: package)
  end

  def actualized_settings(timestamp)
    Rails.cache.fetch(
      "SettingsIndex_#{id}",
      expires_in: MODEL_CACHE_TIMEOUT,
    ) do
      ActualizedSettingsService.call(settings, timestamp)
    end
  end

  def can_view?(object)
    object.published? || user&.can_view?(object)
  end
end
