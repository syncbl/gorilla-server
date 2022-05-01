class Plan < ApplicationRecord
  # Plan types:
  # - Personal (only own packages)
  # - Pro (can publish 10gb)
  # - Business (can publish 100gb and can control endpoints)

  # TODO: Must be rewrited!
  # Bugs: plan used only last, personal is a bullshit.

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
      PLAN_PERSONAL
    when "pro"
      PLAN_PRO
    when "business", "unlimited"
      PLAN_BUSINESS
    else
      0
    end
  end

  private

  def validate_time
    current =
      Plan.current.where(user:).order(end_time: :desc).first
    start_time = current.present? ? current.end_time : Time.current
    self.start_time = start_time
    return unless end_time.nil?

    self.end_time = if user.plan == "unlimited"
        start_time + 100.years
      else
        start_time + 1.month
      end
  end
end
