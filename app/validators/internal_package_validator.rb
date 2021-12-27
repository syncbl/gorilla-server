class InternalPackageValidator < ActiveModel::Validator
  def validate(record)
    if record.path.present?
      if record.path&.match?(Regexp.union(RESTRICTED_PATH_CHARACTERS)) ||
         Pathname.new(record.path).absolute?
        record.errors.add I18n.t("errors.attributes.package.path_not_relative")
      end
    end
  end
end
