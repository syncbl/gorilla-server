class PackageExternalUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && record.sources.any?
      record.errors.add :external_url,
        I18n.t("errors.attributes.package.internal")
    end
  end
end
