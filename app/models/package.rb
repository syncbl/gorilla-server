class Package < ApplicationRecord
  include Discard::Model
  after_discard do
    settings.discard_all
  end

  has_many :settings
  has_many :endpoints, through: :settings
  has_and_belongs_to_many :dependencies,
    class_name: "Package",
    join_table: :dependencies,
    foreign_key: :package_id,
    association_foreign_key: :dependent_package_id
  belongs_to :user, optional: true
  #has_one_attached :icon
  # TODO: So, here is a logic:
  # - Every package has one main file, containing manifest and ONE hardcoded directory.
  # - We can suppose, that for some files user can choose destination, for some not.
  # - /files
  # -       /0
  # -       /1
  # - ...
  # - Manifest YAML contains crc, path, settings, shortcut info etc.
  # - AND SIGNED!

  # For really big archive we need to split it to chunks. I think 50mb will be enough.
  has_many_attached :files
  # TODO: May be move manifest to text field?
  has_one_attached :manifest

  validates :name, presence: true, format: { with: /\A[A-Za-z\d\-\_ ]*\z/ }, length: { maximum: 100 },
    uniqueness: { scope: :user_id, case_sensitive: false }
  validates :alias, format: { with: /\A[A-Za-z\d\-\_]*\z/ },
    uniqueness: { case_sensitive: false }, allow_blank: true
  validates :key, length: {is: 36}, allow_blank: true

  # TODO: GET updated = updated.at > settings.updated_at -> in packages/endpoints/settings?

  # TODO:
  #default_scope -> {
  #  kept
  #  .with_attached_icon
  #}

  def self.all_dependencies(current, packages = [])
    current.dependencies.kept.map do |p|
      if !packages.include?(p)
        if p.dependencies.any?
          packages << p
        else
          packages.unshift(p)
        end
        Package.all_dependencies(p, packages)
      end
    end
    packages
  end

  def to_param
    key
  end

end
