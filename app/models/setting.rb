class Setting < ApplicationRecord
  include IdentityCache

  belongs_to :package, counter_cache: true
  belongs_to :endpoint
  has_many :sources, through: :package

  # TODO: Can't install if no required packages installed
  # TODO: !!! Validate install

  validates :package_id, uniqueness: { scope: :endpoint_id }
  validates_with SettingValidator

  default_scope do
    includes(:package, :endpoint)
  end
end
