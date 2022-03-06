class ExternalParamsValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    record.errors.add :path, I18n.t("errors.attributes.package.external_url_is_empty") if value["external_url"].blank?
  end
end
