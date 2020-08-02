class Endpoint < ApplicationRecord
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
    where(Endpoint.arel_table[:updated_at].gt(Time.current - Rails.application.config.endpoint_token_expiration_time))
  }

  # TODO: Optimize
  def actualize!
    discarded_packages = []
    installed_packages = []
    settings.discarded.where(dependent: false).map { |s| Package.all_dependencies(s.package, discarded_packages) }
    settings.kept.where(dependent: false).map { |s| Package.all_dependencies(s.package, installed_packages) }
    discarded_packages.delete_if { |p| installed_packages.include?(p) }
    settings.kept.where(package: discarded_packages).where(dependent: true).discard_all
    settings.kept.map { |s| installed_packages.delete(s.package) }
    installed_packages.each { |p| settings.create(package: p, dependent: true) }
  end

  def block!(reason = nil)
    self.discarded_at = Time.current
    self.discard_reason = reason
    save!
  end

  def installed?(package)
    settings.kept.find_by(package: package).present?
  end

  def install(package)
    unless settings.find_by(package: package)&.undiscard
      packages << package
    end
    return settings.kept.find_by(package: package)
  rescue
    nil
  end

  def uninstall(package)
    setting = settings.find_by(package: package)
    setting.discard!
    return setting.reload
  rescue
    nil
  end

  def remove(package)
    settings.discarded.find_by(package: package).destroy
  rescue
    false
  end

end
