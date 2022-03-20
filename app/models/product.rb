class Product < ApplicationRecord
  # TODO: License model: single pays for product publication and adverts

  belongs_to :package

  validates :package, uniqueness: true

  scope :published,
        -> {
          includes(:package)
            .where(package: Package.not_blocked.published)
            .without_components
        }
end
