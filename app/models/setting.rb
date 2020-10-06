class Setting < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :created_at

  belongs_to :package
  belongs_to :endpoint #, touch: true
  validates :package_id, uniqueness: { case_sensitive: false, scope: :endpoint_id }

  scope :with_package, -> {
    includes(:package)
  }

  def self.actualize!
    discarded_packages = []
    installed_packages = []
    with_package.where(dependent: false).map { |s|
      if s.discarded?
        s.package.all_dependencies(discarded_packages)
      else
        s.package.all_dependencies(installed_packages)
      end
    }
    discarded_packages.delete_if { |p|
      installed_packages.include?(p)
    }
    kept.where(package: discarded_packages, dependent: true).discard_all
    with_package.kept.map { |s|
      installed_packages.delete(s.package)
    }
    installed_packages.each {
      |p| self.create(package: p, dependent: true)
    }
  end

end
