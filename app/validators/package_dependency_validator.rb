class PackageDependencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, :itself if record.package == value

    # TODO: Duplicate validation!!

    # TODO: Check with CANCANCAN!
    # unless record.package.user.can_view?(value)
    #  record.errors.add :dependent_package,
    #                    I18n.t("errors.attributes.dependency.forbidden")
    # end
  end
  end
