class PackageDependencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.is_component
      record.errors.add :component,
        I18n.t("errors.attributes.package.dependency.not_component")
    end

    if record.package == value
      record.errors.add :component,
        I18n.t("errors.attributes.package.dependency.itself")
    end

    if record.package.external?
      record.errors.add :component,
        I18n.t("errors.attributes.package.dependency.external")
    end

    if !record.package.user.can_view?(value)
      record.errors.add :component,
        I18n.t("errors.attributes.package.dependency.forbidden")
    end

    # TODO: Check deep all dependencies
  end
end
