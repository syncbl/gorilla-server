class Endpoint < ApplicationRecord
  include Blockable

  has_secure_token :authentication_token
  # attribute :locale, :string, default: "en"
  attribute :token

  belongs_to :user, optional: true
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings

  before_create :generate_key

  validates :name,
            length: { maximum: MAX_NAME_LENGTH }
  validates :locale,
            length: { maximum: 10 }
  validates :authentication_token,
            allow_nil: true,
            length: { is: 24 }

  def installed?(package)
    settings.exists?(package: package)
  end

  def install(package)
    settings.create(package: package)
  end

  def reset_token
    regenerate_authentication_token
    self.token = ApiToken.encode(self)
  end
end
