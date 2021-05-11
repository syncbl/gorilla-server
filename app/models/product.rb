class Product < ApplicationRecord
  # TODO: Materialized view

  belongs_to :package

  validates :package,
            presence: true,
            uniqueness: true

  scope :active, -> {
          joins(:package).where(package: Package.active.published)
        }
end
