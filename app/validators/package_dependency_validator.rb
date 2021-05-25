class PackageDependencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.is_component
      record.errors.add :component,
        I18n.t("errors.attributes.package.dependency_not_component")
    end

    if record.package == value
      record.errors.add :component,
        I18n.t("errors.attributes.package.dependency_itself")
    end

    if record.package.external?
      record.errors.add :component,
        I18n.t("errors.attributes.package.external")
    end
    # TODO: Check deep all dependencies
  end
end
