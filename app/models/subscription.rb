class Subscription < ApplicationRecord
  # Subscription types:
  # - Personal (only own packages)
  # - Pro (can publish 10gb)
  # - Business (can publish 100gb and can control endpoints)

  # TODO: Must be rewrited!
  # Bugs: subscription used only last, personal is a bullshit.

  belongs_to :user

  before_create :validate_time

  scope :current,
        -> {
          where(self.arel_table[:start_time].lt(Time.current)).where(
            self.arel_table[:end_time].gt(Time.current),
          )
        }

  def self.active?
    current.first&.user&.plan.in? %w[pro business unlimited]
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
    current =
      Subscription.current.where(user: user).order(end_time: :desc).first
    start_time = current.present? ? current.end_time : Time.current
    self.start_time = start_time
    if self.end_time.nil?
      if user.plan == "unlimited"
        self.end_time = start_time + 100.years
      else
        self.end_time = start_time + 1.month
      end
    end
  end
end
