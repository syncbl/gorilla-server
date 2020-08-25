class Setting < ApplicationRecord
  include Discard::Model

  belongs_to :package
  belongs_to :endpoint #, touch: true
  validates :package_id, uniqueness: { case_sensitive: false, scope: :endpoint_id }

  scope :with_package, -> {
    includes(:package)
  }

end
