class Endpoint < ApplicationRecord
  include Discard::Model

  has_secure_token :authentication_token

  belongs_to :user
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings

  validates :key, length: {is: 36}, allow_blank: true, uniqueness: { case_sensitive: false }

  scope :actual, -> {
    where(Endpoint.arel_table[:updated_at].gt(Time.current - Rails.application.config.token_expiration_time))
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
    self.blocked_at = Time.current
    self.block_reason = reason
    save!
  end

  def installed?(package)
    settings.kept.find_by(package: package).present?
  end

  # TODO: Check save! for correct error
  # TODO: Move settings to other type of db!
  def install(package)
    setting = settings.discarded.find_by(package: package) || settings.new(package: package)
    setting.discarded_at = nil
    setting.save!
  end

  def uninstall(package)
    settings.kept.find_by(package: package)&.discard!
  end

  def to_param
    key
  end
end
