class SourceValidator < ActiveModel::Validator
  def validate(record)
    if record.package.package_type.external?
      record.errors.add I18n.t("errors.attributes.package.external")
    end

    if record.package.user.subscriptions.active?
      # This hack allows to validate source size with user subscription on create
      return unless record.file.attached?

      if record.package.user.used_space + record.file.byte_size.to_i > record.package.user.subscriptions.size_limit
        record.errors.add I18n.t("errors.attributes.source.limit_reached")
      end
    else
      record.errors.add I18n.t("errors.messages.no_subscription")
    end
  end
end
