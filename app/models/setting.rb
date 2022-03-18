class Setting < ApplicationRecord
  include IdentityCache

  belongs_to :package, counter_cache: true
  belongs_to :endpoint
  has_many :sources, through: :package

  validates :package_id, uniqueness: { scope: :endpoint_id }
  validates_with SettingValidator, on: :create
end
