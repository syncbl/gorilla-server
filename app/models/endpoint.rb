class Endpoint < ApplicationRecord
  include ModelBlocker

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
      .gt(Time.current - Rails.application.config.syncbl.endpoint_token_expiration_time))
  }

  attr_accessor :new_token

  def installed?(package)
    settings.exists?(package: package)
  end

  def install(package)
    #packages << package
    settings.find_by(package: package)&.undiscard || settings.create(package: package)
  end

  def actualized_settings
    # TODO: Change behavior to flags
    discard_packages = Set[]
    install_packages = Set[]
    settings.with_package.map do |setting|
      if setting.discarded?
        setting.package.all_dependencies(discard_packages)
      else
        setting.package.all_dependencies(install_packages)
      end
    end
    settings.with_package.all.map do |setting|
      if setting.kept? && discard_packages.include?(setting.package)
        setting.discard
      elsif install_packages.include?(setting.package)
        setting.undiscard
        install_packages.delete(setting.package)
      end
    end
    install_packages.each { |p| settings.create(package: p, dependent: true) }
    settings.reload
  end

end
