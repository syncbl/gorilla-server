class Package < ApplicationRecord
  include Blockable
  include Publishable

  # TODO: MUST!!! Sign packages with endpoint certificate before send and check sign on client-side.

  belongs_to :user
  has_many :settings, dependent: :nullify
  has_many :endpoints, through: :settings
  has_many :sources, dependent: :destroy
  has_and_belongs_to_many :dependencies,
                          class_name: "Package",
                          join_table: :dependencies,
                          foreign_key: :package_id,
                          association_foreign_key: :dependent_package_id
  belongs_to :replacement,
             class_name: "Package",
             optional: true
  has_one_attached :icon,
                   service: :local,
                   dependent: :purge_later

  validates :name,
            name_restrict: true,
            presence: true,
            length: {
              minimum: MIN_NAME_LENGTH,
              maximum: MAX_NAME_LENGTH,
            },
            uniqueness: { scope: :user_id, case_sensitive: false },
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

  scope :published_with,
        ->(user) {
          published.or(where(user: user))
        }

  def all_dependencies(packages = Set[])
    Package.unscoped.all_dependencies(self, packages)
    packages.to_a.reverse
  end

  def self.all_dependencies(package, packages = Set[])
    package.dependencies.map do |p|
      packages << p
      Package.all_dependencies(p, packages)
    end
  end

  def replaced_by
    _replaced_by unless replacement.nil?
  end

  def external?
    !external_url.to_s.strip.empty?
  end

  def self.find_any!(package_id)
    # TODO: We need to prevent creating packages with names from existing id-s
    where(id: package_id).or(where(name: package_id)).first!
  end

  def validated?
    external? ? validated_at.present? : sources.where.not(validated_at: nil).any?
  end

  def published?
    external? ? published_at.present? : sources.where.not(published_at: nil).any?
  end

  private

  def check_external_url
    CheckExternalUrlJob.perform_later self if saved_change_to_external_url?
  end

  def _replaced_by
    # TODO: Check payment i.e.
    replacement.nil? ? self : replacement.replaced_by
  end
end
