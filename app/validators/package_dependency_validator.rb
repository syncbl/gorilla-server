class PackageDependencyValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    if record.package == value
      record.errors.add :dependent_package,
                        I18n.t("errors.attributes.dependency.itself")
    end

    unless record.package.user.can_view?(value)
      record.errors.add :dependent_package,
                        I18n.t("errors.attributes.dependency.forbidden")
    end
  end
end
