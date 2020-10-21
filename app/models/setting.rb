class Setting < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :created_at

  belongs_to :package
  belongs_to :endpoint # TODO: touch: true

  validates :package_id, uniqueness: { case_sensitive: false, scope: :endpoint_id }

  scope :with_package, -> {
    joins(:package)
  }

  scope :updated, -> {
    with_package.where(Setting.arel_table[:updated_at].lt(Package.arel_table[:updated_at]))
  }

end
