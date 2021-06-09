class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :component, class_name: "Package::Component"

  delegate :is_component, to: :component

  validates :component, package_dependency: true

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
