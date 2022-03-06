class ExternalParamsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value["external_url"].blank?
      record.errors.add :path, I18n.t("errors.attributes.package.external_url_is_empty")
    end
  end
end
