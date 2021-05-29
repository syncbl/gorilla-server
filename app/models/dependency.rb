class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :component
  # If we will use package scope then we need to add - class_name: "Package"

  validates :component, package_dependency: true
end
