class PackageReplacementValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.nil? || (value.created_at > record.created_at)
      record.errors[attribute] << I18n.t('activerecord.errors.messages.package_replacement')
    end
  end
end
