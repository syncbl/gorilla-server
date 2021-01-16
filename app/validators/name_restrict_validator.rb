class NameRestrictValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.downcase.in?(RESTRICTED_NAMES)
      record.errors[attribute] << I18n.t('activerecord.errors.messages.name_restrict')
    end
  end
end
