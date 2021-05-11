class Package < ApplicationRecord
  include Blockable
  include Publishable

  # TODO: MUST!!! Sign packages with endpoint certificate before send and check sign on client-side.

  belongs_to :user
  has_one :product
  has_many :settings, dependent: :nullify
  has_many :endpoints, through: :settings
  has_many :sources, dependent: :destroy
  has_many :dependencies
  has_many :dependent_packages, through: :dependencies
  has_and_belongs_to_many :maintainers,
                          class_name: "User",
                          join_table: :maintainers,
                          association_foreign_key: :user_id,
                          dependent: :destroy
  belongs_to :replacement,
             class_name: "Package",
             optional: true
  has_one_attached :icon,
                   service: :internal,
                   dependent: :purge_later

  validates :name,
            name_restrict: true,
            presence: true,
            length: {
              minimum: MIN_NAME_LENGTH,
              maximum: MAX_NAME_LENGTH,
            },
            uniqueness: {
              scope: :user_id,
              case_sensitive: false,
            },
            format: { with: NAME_FORMAT }
  validates :icon, size: { less_than: MAX_ICON_SIZE }
  validates :external_url,
            format: URI.regexp(%w[http https]),
            length: { maximum: 2048 },
            allow_nil: true
  validates :replacement,
            package_replacement: true
  # TODO enumerate validates :destination

  after_save :check_external_url

  def all_dependencies(packages = Set[])
    Package.all_dependencies(self, packages)
    packages.to_a.reverse
  end

  def self.all_dependencies(package, packages = Set[])
    package.dependencies.with_dependency_type(:dependent).map do |p|
      packages << p.dependent_package
      Package.all_dependencies(p.dependent_package, packages)
    end
  end

  def replaced_by
    _replaced_by unless replacement.nil?
  end

  def external?
    !external_url.to_s.strip.empty?
  end

  def validated?
    external? ? validated_at.present? : sources.where.not(validated_at: nil).any?
  end

  def published?
    external? ? published_at.present? : sources.where.not(published_at: nil).any?
  end

  private

  def check_external_url
    if saved_change_to_external_url?
      invalidate!
      CheckExternalUrlJob.perform_later self
    end
  end

  def _replaced_by
    # TODO: Check payment i.e.
    replacement.nil? ? self : replacement.replaced_by
  end
end
