class PackageValidator < ActiveModel::Validator
  def validate(record)
    unless record.external? ||
           record.user.subscriptions.active?
      record.errors.add I18n.t("errors.messages.no_subscription")
    end
  end
end
