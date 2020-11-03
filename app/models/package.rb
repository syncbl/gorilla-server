class Package < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :created_at

  belongs_to :user
  has_many :settings
  has_many :endpoints, through: :settings
  has_many :sources
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

  after_discard do
    # TODO: Change setting discard behavior
    settings.discard_all
    sources.destroy_all
  end

  validates :name, presence: true, length: { maximum: 100 }, name_restrict: true,
    uniqueness: { scope: :user_id, case_sensitive: false }, exclusion: { in: NAME_EXCLUSIONS }
  # TODO: Move aliases to table
  validates :alias, allow_blank: true, uniqueness: { case_sensitive: false },
    name_restrict: true, format: { with: NAME_FORMAT }, exclusion: { in: NAME_EXCLUSIONS }

  scope :allowed_for, -> (user) {
    # TODO Remove nil user, because user can't be blank
    # TODO Group permissions
    kept.where(user: user).or(where(trusted: true))
  }

  def all_dependencies(packages = Set[])
    Package.all_dependencies(self, packages)
    packages.to_a.reverse
  end

  def self.all_dependencies(current, packages = Set[])
    current.dependencies.kept.map do |p|
      packages << p
      Package.all_dependencies(p, packages)
    end
  end

  def self.find_by_alias(package)
    self.find_by(id: package) || self.find_by!(alias: package)
  end

  def replaced?
    replacement.present?
  end

  def replaced_by
    internal_replaced_by unless replacement.nil?
  end

  def title
    if self.alias.present?
      "#{self.name} [#{self.alias}]"
    else
      self.name
    end
  end

  private

  def internal_replaced_by
    replacement.nil? ? self : replacement.replaced_by
  end

end
