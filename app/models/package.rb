class Package < ApplicationRecord
  include Blockable

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

  default_scope {
    joins(:user)
      .includes([:replacement])
      .includes([:icon_attachment])
  }

  scope :apps, -> {
          where(is_component: false)
        }
  scope :published_with,
        ->(user) {
          # TODO Move to policies!!!
          active.where(Package.arel_table[:published_at].lt(Time.current))
          .or(where(user: user))
        }

  def all_dependencies(packages = Set[])
    Package.all_dependencies(self, packages)
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
    external_url.present?
  end

  def self.find_any!(value)
    find_by(id: value) || find_by!(name: value)
  end

  def recalculate_size!
    self.size = 0
    sources.each do |s|
      self.size += s.unpacked_size
    end
    save!
  end

  def published?
    active? && published_at && (published_at < Time.current)
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
