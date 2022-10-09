class SettingValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :user, :no_active_plan unless record.package.user.plans.active?

    if record.package.component? &&
       DependencyExtractService.call(record.endpoint, record.endpoint.packages)
                               .pluck(:dependent_package_id).exclude?(record.package.id)
      record.errors.add :package, :component_without_bundle
    end
  end
end
