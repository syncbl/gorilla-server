class NameRestrictValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    value_d = value.downcase

    if value_d.in?(RESTRICTED_NAMES) || UUID_FORMAT.match?(value_d) ||
       value_d.starts_with?("-")
      record.errors.add attribute, :name_restrict
    end
  end
end
