class DependencyPublishedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.dependency_type.in?(%i[dependent required]) &&
       record.package.published? &&
       !value.published?
      record.errors[attribute] << I18n.t("errors.attributes.package.dependency_unpublished")
    end
  end
end
