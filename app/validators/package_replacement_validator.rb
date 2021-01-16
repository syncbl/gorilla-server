class PackageReplacementValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.nil? || (value.created_at > record.created_at)
      # TODO: I18n
      record.errors[attribute] << 'Replacement must be newer than original package'
    end
  end
end
