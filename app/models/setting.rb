class Setting < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :updated_at

  belongs_to :package
  belongs_to :endpoint #, touch: true
  validates :package_id, uniqueness: { case_sensitive: false, scope: :endpoint_id }

end
