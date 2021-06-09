class SettingPackageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.external?
      record.errors.add :package,
        I18n.t("errors.attributes.setting.only_internal")
    end
  end
end
