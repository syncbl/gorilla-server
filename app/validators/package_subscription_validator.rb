class PackageSubscriptionValidator < ActiveModel::Validator
  def validate(record)
    unless record.external? || record.user.subscriptions.paid?
      record.errors.add :file, I18n.t("errors.messages.no_subscription")
    end
  end
end
