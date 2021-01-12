class NameRestrictValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.downcase.in?(RESTRICTED_NAMES)
      # TODO: I18n
      record.errors[attribute] << 'Restricted name'
    end
  end
end
