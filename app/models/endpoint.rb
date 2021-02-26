class Endpoint < ApplicationRecord
  include Blockable

  has_secure_token :authentication_token
  attribute :locale, :string, default: "en"
  attr_accessor :new_token

  belongs_to :user
  has_many :settings
  has_many :packages, through: :settings
  has_and_belongs_to_many :packages, join_table: :settings, dependent: :destroy

  validates :name,
            length: { maximum: MAX_NAME_LENGTH }
  validates :locale,
            length: { maximum: 10 }
  validates :authentication_token,
            allow_nil: true,
            length: { is: 24 }

  default_scope { joins(:user) }

  # TODO: Move to method in order to show inactive status in list
  #scope :actual, -> {
  #  where(Endpoint.arel_table[:updated_at]
  #    .gt(Time.current - Rails.application.config.syncbl.endpoint_token_expiration_time))
  #}

  def installed?(package)
    settings.exists?(package: package)
  end

  def reset_token
    if new_token.nil?
      regenerate_authentication_token
      self.new_token = JsonWebToken.encode(self)
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
        install_packages << setting.package.replacement
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
        setting.discard unless setting.package.persistent?
      elsif install_packages.include?(setting.package)
        setting.undiscard
        install_packages.delete(setting.package)
      end
    end
    install_packages.each { |p| settings.create(package: p, dependent: true) }
  end
end
