class Package < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :created_at

  has_many :settings
  has_many :endpoints, through: :settings
  has_many :attachments
  has_and_belongs_to_many :dependencies,
    class_name: "Package",
    join_table: :dependencies,
    foreign_key: :package_id,
    association_foreign_key: :dependent_package_id
  belongs_to :user
  belongs_to :replacement, class_name: "Package", optional: true

  has_one_attached :icon
  has_many_attached :parts

  after_discard do
    settings.discard_all
  end

  validates :name, presence: true, length: { maximum: 100 },
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

  def all_dependencies(packages = [])
    Package.all_dependencies(self, packages)
  end

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

  def self.find_by_alias(reader: nil, owner: nil, package: nil)
    # TODO: Check permissions, because allowed_for can be overrided by find_by
    packages = Package.allowed_for(reader)
    if owner
      packages.find_by(user: owner, id: package) || packages.find_by!(user: owner, alias: package)
    else
      packages.find_by(id: package) || packages.find_by!(alias: package)
    end
  end

  def replaced?
    replacement.present?
  end

  def replaced_by
    internal_replaced_by unless replacement.nil?
  end

  private

  def internal_replaced_by
    if replacement.nil?
      self
    else
      replacement.replaced_by
    end
  end

end
