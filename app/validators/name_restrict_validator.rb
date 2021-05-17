class NameRestrictValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.to_s.strip.empty?
    valid_uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    value_d = value.downcase

    if value_d.in?(RESTRICTED_NAMES) || valid_uuid.match?(value_d)
      record.errors[attribute] << I18n.t('errors.messages.name_restrict')
    end
  end
end
