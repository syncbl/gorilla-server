class Endpoint < ApplicationRecord
  # TODO: Replace discard with state enum.
  include Discard::Model

  self.implicit_order_column = :created_at

  has_secure_token :authentication_token
  belongs_to :user
  has_many :settings
  has_many :packages, through: :settings
  has_and_belongs_to_many :packages,
   join_table: :settings,
   dependent: :destroy

  scope :actual, -> {
    where(Endpoint.arel_table[:updated_at]
      .gt(Time.current - Rails.application.config.syncable.endpoint_token_expiration_time))
  }

  def block!(reason = nil)
    self.discarded_at = Time.current
    self.discard_reason = reason
    save!
  end

  def installed?(package)
    settings.exists?(package: package)
  end

  def install(package)
    settings.find_by(package: package)&.touch || packages << package
  end

  def actualized_settings
    # TODO: Change behavior to flags
    discard_packages = []
    install_packages = []
    settings.with_package.map do |setting|
      if setting.discarded?
        setting.package.all_dependencies(discard_packages)
      else
        setting.package.all_dependencies(install_packages)
      end
    end
    discard_packages.delete_if { |package| install_packages.include?(package) }
    settings.kept.where(package: discard_packages, dependent: true).discard_all
    settings.where(package: install_packages).map do |setting|
      if setting.discarded?
        setting.undiscard
      end
      install_packages.delete(setting.package)
    end
    ap install_packages
    install_packages.each do |package|
      settings.create(package: package, dependent: true)
    end
    settings
  end

end
