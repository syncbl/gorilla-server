class InternalParamsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.bundle?
      if value["path"].blank?
        record.errors.add :path, I18n.t("errors.attributes.package.path_is_empty")
      end
      if value["root"].blank?
        record.errors.add :path, I18n.t("errors.attributes.package.root_is_empty")
      end
      # elsif record.component?
    end

    unless value["path"].nil?
      if value["path"].match?(Regexp.union(RESTRICTED_PATH_CHARACTERS)) ||
         Pathname.new(value["path"]).absolute?
        record.errors.add :path, I18n.t("errors.attributes.package.path_not_relative")
      end
    end
  end
end
