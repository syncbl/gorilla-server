class DependencyValidator < ActiveModel::Validator
  def validate(record)
    if record.package.external? &&
       record.component?
      record.errors.add :dependent_package,
                        I18n.t("errors.attributes.dependency.external")
    end
  end
end
