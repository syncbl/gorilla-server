class Subscription < ApplicationRecord
  # Subscription types:
  # - Personal (only own packages)
  # - Pro (can publish 10gb)
  # - Business (can publish 100gb and can control endpoints)

  belongs_to :user

  before_create :validate_time

  scope :active, -> {
          where(self.arel_table[:start_time].lt(Time.current))
            .where(self.arel_table[:end_time].gt(Time.current))
        }

  def self.paid?
    self.active.any?
  end

  def self.extended?
    paid? && %w[professional business].include?(active.first.user.plan)
  end

  private

  def validate_time
    current = Subscription.where(user: user).order(end_time: :desc).first
    start_time = current.present? ? current.end_time : Time.current
    self.start_time = start_time
    self.end_time = start_time + 1.month
  end
end
