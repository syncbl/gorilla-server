class PackageMaintainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.package.user == value
      record.errors.add :component,
        I18n.t("errors.attributes.package.owner_already")
    end
  end
end
