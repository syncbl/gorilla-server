class Package < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :created_at

  has_many :endpoints, through: :settings
  has_and_belongs_to_many :dependencies,
    class_name: "Package",
    join_table: :dependencies,
    foreign_key: :package_id,
    association_foreign_key: :dependent_package_id
  belongs_to :user, optional: true

  # For really big archive we need to split it to chunks. I think 50mb will be enough.
  has_many_attached :files
  has_many_attached :parts

  after_discard do
    settings.discard_all
  end

  validates :name, presence: true, format: { with: /\A[A-Za-z\d\-\_ ]*\z/ }, length: { maximum: 100 },
    uniqueness: { scope: :user_id, case_sensitive: false }
  validates :alias, format: { with: /\A[A-Za-z\d\-\_]*\z/ },
    uniqueness: { case_sensitive: false }, allow_blank: true

  scope :allowed_for, -> (user) {
    if user
      kept.where(user: user, trusted: false).or(where(trusted: true))
    else
      kept.where(trusted: true)
    end
  }

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
    return packages
  end

end
