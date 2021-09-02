class Product < ApplicationRecord
  # TODO: License model: single pays for product publication and adverts

  belongs_to :package

  validates :package, presence: true, uniqueness: true

  scope :published,
        -> {
          joins(:package)
            .where(package: Package.except_blocked.published)
            .without_components
        }
end
