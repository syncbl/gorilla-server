class Setting < ApplicationRecord
  include Discard::Model

  # TODO: What to do if package is deleted?
  belongs_to :package
  belongs_to :endpoint # TODO: touch: true

  validates :package_id, uniqueness: { scope: :endpoint_id }

  #encrypts :data, algorithm: "hybrid", encryption_key: encryption_key, decryption_key: decryption_key

  default_scope { includes(:package) }

  scope :updated,
        -> {
          where(
            Setting.arel_table[:updated_at].lt(Package.arel_table[:updated_at])
          )
        }

  def replaced?
    package.replacement.present?
  end
end
