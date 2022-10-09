class PackageValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :user, :no_active_plan unless record.external? || record.user&.plans&.active?
  end
end
