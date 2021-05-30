class Setting < ApplicationRecord
  include Discard::Model

  belongs_to :package, counter_cache: true
  belongs_to :source, counter_cache: true, optional: true
  belongs_to :endpoint

  encrypts :data, algorithm: "hybrid",
                  encryption_key: -> { endpoint.encryption_key },
                  decryption_key: -> { endpoint.decryption_key }

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
