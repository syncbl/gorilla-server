class Setting < ApplicationRecord
  include IdentityCache

  belongs_to :package, counter_cache: true
  belongs_to :endpoint
  has_many :sources, through: :package

  # TODO: Can't install if no required packages installed
  # TODO: Validate install

  validates :package_id, uniqueness: { scope: :endpoint_id }

  default_scope {
    includes(:package, :endpoint)
  }

  # TODO: Check scope to get really updated packages
  scope :updated,
        -> {
          # ??? joins(:package).
          where(
            self.arel_table[:updated_at].lt(Package.arel_table[:updated_at])
          )
        }

  def replaced?
    package.replacement_id.present?
  end
end
