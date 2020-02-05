class Package < ApplicationRecord
  include Discard::Model

  has_many :settings, dependent: :destroy
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
  has_one_attached :manifest

  validates :name, presence: true, format: { with: /\A[A-Za-z0-9\d\-_ ]*\z/ }, uniqueness: { scope: :user_id, case_sensitive: false }
  validates :alias, format: { with: /\A[A-Za-z0-9\d\-_ ]*\z/ }, uniqueness: { case_sensitive: false }
  validates :key, length: {is: 36}, allow_blank: true

  # TODO:
  #default_scope -> {
  #  kept
  #  .with_attached_icon
  #}

  def all_dependencies(packages = [])
    dependencies.kept.map do |p|
      if !packages.include?(p)
        if p.dependencies.any?
          packages << p
        else
          packages.unshift(p)
        end
        all_dependencies(packages)
      end
    end
    packages
  end

  def to_param
    key
  end

end
