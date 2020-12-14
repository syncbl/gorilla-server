class NameRestrictValidator < ActiveModel::EachValidator
  RESTRICTED_NAMES = %w[
    packages
    endpoint
    user
    users
    endpoint
    endpoints
    settings
    sign_in
    sign_out
  ]

  def validate_each(record, attribute, value)
    if value.downcase.in?(RESTRICTED_NAMES)
      # TODO: I18n
      record.errors[attribute] << 'Restricted name'
    end
  end
end
