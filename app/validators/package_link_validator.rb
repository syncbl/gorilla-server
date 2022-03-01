class PackageLinkValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      value.each do |v|
        source, destination = v.split(":")
        # TODO: Check if path in filelist
        unless source.present? && Pathname.new(source).relative? &&
               destination.present? && Pathname.new(destination).relative?
          record.errors.add attribute, I18n.t("errors.attributes.package.link_not_valid")
        end
      end
    end
  end
end
