class DependencyPublishedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.dependency_type.in?(%i[required]) && !value.published?
      record.errors[attribute] << I18n.t("errors.attributes.package.dependency_unpublished")
    elsif record.dependency_type.in?(%i[component optional]) && !value.is_component
      record.errors[attribute] << I18n.t("errors.attributes.package.dependency_not_component")
    end
  end
end
