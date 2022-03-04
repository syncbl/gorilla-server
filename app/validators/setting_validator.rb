class SettingValidator < ActiveModel::Validator
  def validate(record)
    if record.package.component? &&
       DependencyExtractService.call(record.endpoint).pluck(:dependent_package_id).exclude?(record.package.id)
      record.errors.add I18n.t("errors.attributes.setting.component_without_bundle")
    end
  end
end
