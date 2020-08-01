class Endpoint < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :created_at

  has_secure_token :authentication_token
  belongs_to :user
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

  # TODO: Check save! for correct error
  # TODO: Move settings to other type of db!
  def install(package)
    packages << package
  rescue
    false
  end

  def uninstall(package)
    packages.kept.find_by(package: package)&.discard!
  end
end
