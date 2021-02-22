class Setting < ApplicationRecord
  include Discard::Model

  # TODO: What to do if package is deleted?
  belongs_to :package
  belongs_to :endpoint # TODO: touch: true

  validates :package_id, uniqueness: { scope: :endpoint_id }

  #encrypts :data, algorithm: "hybrid", encryption_key: encryption_key, decryption_key: decryption_key

  default_scope { joins(:package) }

  scope :updated,
        -> {
          where(
            Setting.arel_table[:updated_at].lt(Package.arel_table[:updated_at])
          )
        }

  def self.actualize!
    # TODO: Replace discard with events
    discard_packages = Set[]
    install_packages = Set[]
    self.map do |setting|
      if setting.package.replaced?
        # TODO: Add upgrade strategy
        setting.discard
        discard_packages << setting.package
        install_packages << setting.package.replacement
      end
    end
    self.map do |setting|
      if setting.discarded?
        setting.package.all_dependencies(discard_packages)
      else
        setting.package.all_dependencies(install_packages)
      end
    end
    self.map do |setting|
      if setting.kept? && discard_packages.include?(setting.package)
        setting.discard unless setting.package.persistent?
      elsif install_packages.include?(setting.package)
        setting.undiscard
        install_packages.delete(setting.package)
      end
    end
    install_packages.each { |p| self.create(package: p, dependent: true) }
  end
end
