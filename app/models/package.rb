class Package < ApplicationRecord
  include ModelBlocker

  self.implicit_order_column = :created_at

  belongs_to :user
  has_many :settings, dependent: :destroy
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

  has_one_attached :icon
  has_many_attached :parts

  validates :name, presence: true, length: { maximum: MAX_PACKAGE_NAME_LENGTH }, name_restrict: true,
    uniqueness: { scope: :user_id, case_sensitive: false }, exclusion: { in: NAME_EXCLUSIONS }
  # TODO: Move aliases to table
  validates :alias, allow_blank: true, uniqueness: { case_sensitive: false },
    name_restrict: true, format: { with: NAME_FORMAT }, exclusion: { in: NAME_EXCLUSIONS }
  validates :icon, size: { less_than: 1.megabyte }
  validates :parts, content_type: 'application/zip', size: { less_than: 1.gigabyte }

  scope :allowed_for, -> (user) {
    # TODO Remove nil user, because user can't be blank
    # TODO Group permissions
    where(user: user).or(where(trusted: true))
  }

  def all_dependencies(packages = Set[])
    Package.all_dependencies(self, packages)
    packages.to_a.reverse
  end

  def self.all_dependencies(current, packages = Set[])
    current.dependencies.map do |p|
      packages << p
      Package.all_dependencies(p, packages)
    end
  end

  def self.find_by_alias(value)
    self.find_by(id: value) || self.find_by!(alias: value)
  end

  def replaced?
    replacement.present?
  end

  def replaced_by
    internal_replaced_by unless replacement.nil?
  end

  def title
    self.alias.present? ? "#{self.name} [#{self.alias}]" : self.name
  end

  def update_sources!
    current_size = 0
    sources.map do |source|
      current_size += source.size
    end
    self.size = current_size
    save
  end

  private

  def internal_replaced_by
    replacement.nil? ? self : replacement.replaced_by
  end

end
