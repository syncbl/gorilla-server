class Setting < ApplicationRecord
  belongs_to :package, counter_cache: true
  belongs_to :endpoint

  # TODO: Can't install if no required packages installed

  validates :package_id, uniqueness: { scope: :endpoint_id }

  # TODO: Check scope to get really updated packages
  scope :updated,
        -> {
          joins(:package).where(
            self.arel_table[:updated_at].lt(Package.arel_table[:updated_at])
          )
        }

  def replaced?
    package.replacement_id.present?
  end
end
