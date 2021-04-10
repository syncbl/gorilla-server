class Endpoint < ApplicationRecord
  include Blockable

  has_secure_token :authentication_token
  # attribute :locale, :string, default: "en"
  attr_accessor :token

  belongs_to :user
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings

  validates :name,
            length: { maximum: MAX_NAME_LENGTH }
  validates :locale,
            length: { maximum: 10 }
  validates :authentication_token,
            allow_nil: true,
            length: { is: 24 }

  default_scope { joins(:user) }

  def installed?(package)
    settings.exists?(package: package)
  end

  def install(package)
    settings.create(package: package)
  end

  def reset_token
    if token.nil?
      regenerate_authentication_token
      self.token = JsonWebToken.encode(self)
    end
  end

  def actualize!
    # TODO: Replace discard with events
    discard_packages = Set[]
    install_packages = Set[]
    settings.map do |setting|
      if setting.replaced?
        # TODO: Add upgrade strategy
        setting.discard
        discard_packages << setting.package
        install_packages << setting.package.replaced_by
      end
    end
    settings.map do |setting|
      if setting.discarded?
        setting.package.all_dependencies(discard_packages)
      else
        setting.package.all_dependencies(install_packages)
      end
    end
    settings.map do |setting|
      if setting.kept? && discard_packages.include?(setting.package)
        setting.discard
      elsif install_packages.include?(setting.package)
        setting.undiscard
        install_packages.delete(setting.package)
      end
    end
    install_packages.each { |p| settings.create(package: p) }
  end
end
