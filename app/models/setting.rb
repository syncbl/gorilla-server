class Setting < ApplicationRecord
  belongs_to :package
  belongs_to :endpoint, touch: true
  validates_uniqueness_of :package_id, scope: :endpoint_id

end
