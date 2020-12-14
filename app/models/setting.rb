class Setting < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :created_at

  # TODO: What to do if package is deleted?
  belongs_to :package
  belongs_to :endpoint # TODO: touch: true

  validates :package_id, uniqueness: { scope: :endpoint_id }

  #encrypts :data, algorithm: "hybrid", encryption_key: encryption_key, decryption_key: decryption_key

  scope :with_package, -> { joins(:package) }

  scope :updated,
        -> {
          with_package.where(
            Setting.arel_table[:updated_at].lt(Package.arel_table[:updated_at])
          )
        }
end
