class Endpoint < ApplicationRecord
  include Blockable

  self.implicit_order_column = :created_at

  has_secure_token :authentication_token
  belongs_to :user
  has_many :settings
  has_many :packages, through: :settings
  has_and_belongs_to_many :packages, join_table: :settings, dependent: :destroy

  # TODO: Move to method in order to show inactive status in list
  #scope :actual, -> {
  #  where(Endpoint.arel_table[:updated_at]
  #    .gt(Time.current - Rails.application.config.syncbl.endpoint_token_expiration_time))
  #}

  scope :with_user, -> { joins(:user) }

  attr_accessor :new_token

  def installed?(package)
    settings.exists?(package: package)
  end

end
