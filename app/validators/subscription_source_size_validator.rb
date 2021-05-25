class SubscriptionSourceSizeValidator < ActiveModel::Validator
  def validate(record)
    # This hack allows to validate source size with user subscription on create
    return if record.size.nil?
    if record.package.user.used_space + record.size > record.package.user.subscriptions.size_limit
      record.errors.add :file, I18n.t("errors.attributes.source.limit_reached")
    end
  end
end
