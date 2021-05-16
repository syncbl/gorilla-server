class Setting < ApplicationRecord
  include Discard::Model

  belongs_to :package, counter_cache: true
  belongs_to :endpoint

  validates :package_id, uniqueness: { scope: :endpoint_id }

  #encrypts :data, algorithm: "hybrid", encryption_key: encryption_key, decryption_key: decryption_key

  scope :with_includes,
        -> {
          includes(package: [:icon_attachment,
                             :replacement,
                             :dependencies,
                             :dependent_packages])
        }

  scope :updated,
        -> {
          where(
            self.arel_table[:updated_at].lt(Package.arel_table[:updated_at])
          )
        }

  def replaced?
    package.replacement.present?
  end
end
