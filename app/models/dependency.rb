class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :component, class_name: "Package::Component"

  validates :component, package_dependency: true
end
