class PackageValidator < ActiveModel::Validator
  def validate(record)
    unless record.external? || record.user&.plans&.active?
      record.errors.add I18n.t("errors.messages.no_plan")
    end
  end
end
