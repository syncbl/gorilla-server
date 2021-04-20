class Setting < ApplicationRecord
  include Discard::Model

  # TODO: What to do if package is deleted?
  belongs_to :package, counter_cache: true
  belongs_to :endpoint # TODO: touch: true

  validates :package_id, uniqueness: { scope: :endpoint_id }

  #encrypts :data, algorithm: "hybrid", encryption_key: encryption_key, decryption_key: decryption_key

  before_create :check_permissions

  default_scope { includes(package: [:replacement, :dependencies]) }

  scope :updated,
        -> {
          where(
            Setting.arel_table[:updated_at].lt(Package.arel_table[:updated_at])
          )
        }

  def replaced?
    package.replacement.present?
  end

  def self.actualized!
    # TODO: Replace discard with events
    discard_packages = Set[]
    install_packages = Set[]
    settings = all
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
    install_packages.each { |p| create(package: p) }
    settings.reload
  end

  private

  def check_permissions
    package.published? || (package.user == endpoint.user)
  end
end
