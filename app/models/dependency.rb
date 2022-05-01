class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :dependent_package, class_name: "Package"
  belongs_to :category, optional: true

  validates :dependent_package, package_dependency: true
  validates_with DependencyValidator

  default_scope do
    includes(:dependent_package, :category)
  end

  scope :categorized, -> {
                        order(:category_id)
                      }

  def required_component?
    !optional? && dependent_package.component?
  end

  def optional_component?
    optional? && dependent_package.component?
  end

  def required_package?
    !optional? && dependent_package.bundle?
  end

  def optional_package?
    optional? && dependent_package.bundle?
  end
end
