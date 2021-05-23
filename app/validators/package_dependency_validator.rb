class PackageDependencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.is_component
      record.errors.add :component,
        I18n.t("errors.attributes.package.dependency_not_component")
    elsif record.package == value
      record.errors.add :component,
        I18n.t("errors.attributes.package.dependency_itself")
    end
  end
end
