class InternalParamsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.bundle?
      record.errors.add attribute, :path_is_empty if value["path"].blank?
      record.errors.add attribute, :root_is_empty if value["root"].blank?
      # elsif record.component?
    end

    return if value["path"].nil?

    if value["path"].match?(Regexp.union(RESTRICTED_PATH_CHARACTERS)) ||
       Pathname.new(value["path"]).absolute?
      record.errors.add attribute, :path_not_relative
    end
  end
end
