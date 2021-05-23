class PackageReplacementValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && (value.created_at < record.created_at)
      record.errors.add :replaced_by,
        I18n.t("errors.attributes.package.replacement_old")
    elsif record == value
      record.errors.add :replaced_by,
        I18n.t("errors.attributes.package.replacement_itself")
    end
  end
end
