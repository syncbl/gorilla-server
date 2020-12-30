class NameRestrictValidator < ActiveModel::EachValidator
  RESTRICTED_NAMES = %w[
    sign_in
    sign_out
    package
    packages
    user
    users
    endpoint
    endpoints
    setting
    settings
    source
    sources
    storage
  ]

  def validate_each(record, attribute, value)
    if value.downcase.in?(RESTRICTED_NAMES)
      # TODO: I18n
      record.errors[attribute] << 'Restricted name'
    end
  end
end
