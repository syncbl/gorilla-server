class PackageDependencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.package == value
      record.errors.add :dependent_package,
        I18n.t("errors.attributes.package.dependency.itself")
    end

    if record.package.is_external && record.is_component
      record.errors.add :dependent_package,
        I18n.t("errors.attributes.package.dependency.external")
    end

    unless record.package.user.can_view?(value)
      record.errors.add :dependent_package,
        I18n.t("errors.attributes.package.dependency.forbidden")
    end

    # TODO: Check deep all dependencies
  end
end
