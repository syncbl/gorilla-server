class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :component,
             class_name: "Package"

  validates_each :component do |record, attr, value|
    if !value.is_component
      record.errors.add :component, I18n.t("errors.attributes.package.dependency_not_component")
    elsif record.package == value
      record.errors.add :component, I18n.t("errors.attributes.package.dependency_itself")
    end
  end

  # TODO: Check dependency:
  # - not same id
  # - no crossreference
end
