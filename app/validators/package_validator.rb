class PackageValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add I18n.t("errors.messages.no_plan") unless record.external? || record.user&.plans&.active?
  end
end
