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
          where(arel_table[:start_time].lt(Time.current)).where(
            arel_table[:end_time].gt(Time.current),
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
    if end_time.nil?
      self.end_time = if user.plan == "unlimited"
        start_time + 100.years
      else
        start_time + 1.month
                      end
    end
  end
end
