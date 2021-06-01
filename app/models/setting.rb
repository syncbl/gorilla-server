class Setting < ApplicationRecord
  belongs_to :package, counter_cache: true
  belongs_to :source, counter_cache: true, optional: true
  belongs_to :endpoint

  validates :package_id, uniqueness: { scope: :endpoint_id }

  scope :with_includes,
        -> {
          includes([:package])
        }
  scope :updated,
        -> {
          where(
            self.arel_table[:updated_at].lt(Package.arel_table[:updated_at])
          )
        }

  def replaced?
    package.replacement_id.present? &&
    endpoint.user.can_view?(package.replaced_by)
  end
end
