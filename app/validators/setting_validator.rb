class SettingValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add I18n.t("errors.attributes.setting.no_active_plan") unless record.package.user.plans.active?

    if record.package.component? &&
       DependencyExtractService.call(record.endpoint, record.endpoint.packages)
                               .pluck(:dependent_package_id).exclude?(record.package.id)
      record.errors.add :package, I18n.t("errors.attributes.setting.component_without_bundle")
    end
  end
end
