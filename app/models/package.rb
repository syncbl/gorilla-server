class Package < ApplicationRecord
  include Discard::Model

  has_many :settings
  has_many :endpoints, through: :settings
  has_and_belongs_to_many :dependencies,
    class_name: "Package",
    join_table: :dependencies,
    foreign_key: :package_id,
    association_foreign_key: :dependent_package_id
  belongs_to :user, optional: true
  has_one_attached :icon
  has_many_attached :files

  validates :alias, format: { with: /\A[A-Za-z\d\-_ ]*\z/ }
  validates :key, length: {is: 36}, allow_blank: true

  #default_scope -> {
  #  kept
  #  .with_attached_icon
  #}

  def all_dependencies(packages = [])
    dependencies.map do |p|
      if !packages.include?(p)
        if p.dependencies.any?
          packages << p
        else
          packages.unshift(p)
        end
        # TODO: May be, counter?
        all_dependencies(packages)
      end
    end
    packages
  end

  def to_param
    key
  end

end
