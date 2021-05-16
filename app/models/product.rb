class Product < ApplicationRecord
  # TODO: License model: single pays for product publication and adverts

  belongs_to :package

  validates :package,
            presence: true,
            uniqueness: true

  scope :active, -> {
          joins(:package).where(package: Package.active.published)
            .where.not(validated_at: nil)
        }
end
