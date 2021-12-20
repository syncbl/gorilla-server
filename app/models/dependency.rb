class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :dependent_package, class_name: "Package"
  belongs_to :category, optional: true

  delegate :package_type, to: :dependent_package

  validates :dependent_package, package_dependency: true
  validates_with DependencyValidator

  default_scope {
    includes(:dependent_package, :category)
  }

  scope :categorized, -> {
          order(:category_id)
                      }

  def required_component?
    package_type.component? && !is_optional
  end

  def optional_component?
    package_type.component? && is_optional
  end

  def required_package?
    !package_type.component? && !is_optional
  end

  def optional_package?
    !package_type.component? && is_optional
  end
end
