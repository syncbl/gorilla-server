class Package < ApplicationRecord
  include Blockable

  # TODO: MUST!!! Sign packages with endpoint certificate before send and check sign on client-side.

  belongs_to :user
  belongs_to :published_by,
             class_name: "User",
             optional: true
  has_many :settings, dependent: :destroy
  has_many :endpoints, through: :settings
  has_many :sources, dependent: :destroy
  # TODO: Remove files like GIT after delete by nullifying crc in filelist

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
  # TODO: Check link for content disposition
  validates :external_url,
            format: URI.regexp(%w[http https]),
            length: { maximum: 2048 },
            allow_nil: true
  validates :replacement,
            package_replacement: true
  # TODO enumerate validates :destination

  before_validation { name.downcase! }
  after_validation :check_external_url

  default_scope { joins(:user) }

  scope :apps, -> {
          where(is_component: false)
        }

  scope :allowed_for,
        ->(user) {
          # TODO Remove nil user, because user can't be blank
          # TODO Group permissions
          # TODO Move to policies!!!
          where(user: user).or(where.not(published_by: nil))
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

  def internal?
    sources.kept.active.each do |s|
      return true if s.file.attached?
    end
    false
  end

  def external?
    external_url.present?
  end

  def self.find_any!(value)
    # TODO: Add alias search
    find_by(id: value) || find_by!(name: value)
  end

  def recalculate_size!
    self.size = 0
    sources.each do |s|
      self.size += s.unpacked_size
    end
    save!
  end

  private

  def check_external_url
    self.size = UrlRequest.get_attachment_size(external_url).to_i if external_url.present?
  rescue StandardError => e
    errors.add(:external_url, I18n.t("model.package.error.check_external_url"))
    # TODO: Log e with url
  end

  def _replaced_by
    replacement.nil? ? self : replacement.replaced_by
  end
end
