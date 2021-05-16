class Product < ApplicationRecord
  # TODO: Materialized view including check for subscription

  # TODO: License model: user pays for product publication and adverts

  belongs_to :package

  validates :package,
            presence: true,
            uniqueness: true

  scope :active, -> {
          joins(:package).where(package: Package.active.published)
            .where.not(published_at: nil)
        }
end
