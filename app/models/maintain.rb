class Maintain < ApplicationRecord
  belongs_to :package
  belongs_to :user

  validates_each :user do |record, attr, value|
    if record.package.user == value
      record.errors.add :component, I18n.t("errors.attributes.package.owner_already")
    end
  end
end
