class PackageMaintainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.package.user == value
      record.errors.add :maintainers,
        I18n.t("errors.attributes.package.owner_already")
    end

    unless value.subscriptions.paid?
      record.errors.add :maintainers,
        I18n.t("errors.messages.no_maintainer_subscription")
    end
  end
end
