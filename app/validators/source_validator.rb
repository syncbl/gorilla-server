class SourceValidator < ActiveModel::Validator
  def validate(record)
    if record.package.package_type.external?
      record.errors.add I18n.t("errors.attributes.package.external")
    end

    unless record.package.user.subscriptions.active?
      record.errors.add I18n.t("errors.messages.no_subscription")
    else
      # This hack allows to validate source size with user subscription on create
      return if record.size.nil?
      if record.package.user.used_space + record.size > record.package.user.subscriptions.size_limit
        record.errors.add I18n.t("errors.attributes.source.limit_reached")
      end
    end
  end
end
