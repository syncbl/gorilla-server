class NameRestrictValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid_uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    value_d = value.downcase

    if value.present? && value_d.in?(RESTRICTED_NAMES) && valid_uuid.match?(value)
      record.errors[attribute] << I18n.t('activerecord.errors.messages.name_restrict')
    end
  end
end
