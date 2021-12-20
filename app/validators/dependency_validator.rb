class DependencyValidator < ActiveModel::Validator
  def validate(record)
    if record.package.package_type.external? && record.package_type.component?
      record.errors.add :dependent_package,
                        I18n.t("errors.attributes.package.dependency.external")
    end
  end
end
