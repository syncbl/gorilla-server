class InternalParamsValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    if record.bundle?
      record.errors.add :path, I18n.t("errors.attributes.package.path_is_empty") if value["path"].blank?
      record.errors.add :path, I18n.t("errors.attributes.package.root_is_empty") if value["root"].blank?
      # elsif record.component?
    end

    return if value["path"].nil?

    if value["path"].match?(Regexp.union(RESTRICTED_PATH_CHARACTERS)) ||
       Pathname.new(value["path"]).absolute?
      record.errors.add :path, I18n.t("errors.attributes.package.path_not_relative")
    end
  end
end
