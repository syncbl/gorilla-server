class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :component, class_name: "Package::Component"

  delegate :is_component, to: :component

  validates :component, package_dependency: true

  scope :required_components, -> {
          include(:component)
            .where(component: { is_component: true })
            .where(is_optional: false)
        }
  scope :optional_components, -> {
          include(:component)
            .where(component: { is_component: true })
            .where(is_optional: true)
        }
  scope :required_packages, -> {
          include(:component)
            .where(component: { is_component: false })
            .where(is_optional: false)
        }
  scope :optional_packages, -> {
          include(:component)
            .where(component: { is_component: false })
            .where(is_optional: true)
        }
end
