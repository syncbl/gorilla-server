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
    !optional? && package_type == :component
  end

  def optional_component?
    optional? && package_type == :component
  end

  def required_package?
    !optional? && package_type == :bundle
  end

  def optional_package?
    optional? && package_type == :bundle
  end
end
