class SourceValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    check_package_not_external
    check_subscription
    check_last_source_not_partial
  end

  private

  def check_package_not_external
    return unless @record.package.package_type.external?

    @record.errors.add I18n.t("errors.attributes.package.external")
  end

  def check_subscription
    if @record.package.user.subscriptions.active?
      # This hack allows to validate source size with user subscription on create
      return unless @record.file.attached?

      if @record.package.user.used_space + @record.file.byte_size.to_i > @record.package.user.subscriptions.size_limit
        @record.errors.add I18n.t("errors.attributes.source.limit_reached")
      end
    else
      @record.errors.add I18n.t("errors.messages.no_subscription")
    end
  end

  def check_last_source_not_partial
    return unless @record.id.nil? || (@record == @record.package.sources.last)
    return unless @record.partial?

    @record.errors.add I18n.t("errors.attributes.source.last_cannot_be_partial")
  end
end
