class Subscription < ApplicationRecord
  # Subscription types:
  # - Personal (only own packages)
  # - Pro (can publish 10gb)
  # - Business (can publish 100gb and can control endpoints)

  belongs_to :user

  before_create :validate_time

  scope :current, -> {
          where(self.arel_table[:start_time].lt(Time.current))
            .where(self.arel_table[:end_time].gt(Time.current))
        }

  def self.paid?
    self.current.any? || self.user.plan == "unlimited"
  end

  def self.extended?
    paid? && %w[pro business].include?(current.last.user.plan)
  end

  def self.size_limit
    case current.last.user.plan
    when "personal"
      SUBSCRIPTION_PLAN_PERSONAL
    when "pro"
      SUBSCRIPTION_PLAN_PRO
    when "business"
      SUBSCRIPTION_PLAN_BUSINESS
    when "unlimited"
      SUBSCRIPTION_PLAN_BUSINESS
    else
      0
    end
  end

  private

  def validate_time
    current = Subscription.current.where(user: user).order(end_time: :desc).first
    start_time = current.present? ? current.end_time : Time.current
    self.start_time = start_time
    self.end_time = start_time + 1.month
  end
end
