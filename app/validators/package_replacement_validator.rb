class PackageReplacementValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.nil? || (value.created_at > record.created_at)
      record.errors.add :replaced_by,
        I18n.t("errors.attributes.package.replacement_old")
    end
  end
end
