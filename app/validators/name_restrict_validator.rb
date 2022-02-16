class NameRestrictValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      value_d = value.downcase

      if value_d.in?(RESTRICTED_NAMES) || UUID_FORMAT.match?(value_d) ||
         value_d.starts_with?("-")
        record.errors.add attribute, I18n.t("errors.messages.name_restrict")
      end
    end
  end
end
