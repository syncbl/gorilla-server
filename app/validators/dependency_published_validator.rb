class DependencyPublishedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.dependency_type.in?(%i[required optional]) && !value.published?
      record.errors[attribute] << I18n.t("errors.attributes.package.dependency_unpublished")
    elsif !value.is_component
      record.errors[attribute] << I18n.t("errors.attributes.package.dependency_not_component")
    end
  end
end
