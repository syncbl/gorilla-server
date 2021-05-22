class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :component,
             class_name: "Package"

  validates :component, package_dependency: true

  # TODO: Check dependency:
  # - no crossreference
end
