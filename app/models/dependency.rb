class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :dependent_package, class_name: "Package"

  delegate :is_component, to: :dependent_package

  validates :dependent_package, package_dependency: true

  default_scope {
    includes([:dependent_package])
  }

  def required_component?
    is_component && !is_optional
  end

  def optional_component?
    is_component && is_optional
  end

  def required_package?
    !is_component && !is_optional
  end

  def optional_package?
    !is_component && is_optional
  end
end
