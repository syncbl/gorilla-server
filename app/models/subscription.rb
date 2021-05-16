class Subscription < ApplicationRecord
  # Subscription allows to use more space for packages

  belongs_to :user

  before_create :validate_time

  scope :active, -> {
          where(self.arel_table[:start_time].lt(Time.current))
            .where(self.arel_table[:end_time].gt(Time.current))
        }

  def self.paid?
    self.active.any?
  end

  private

  def validate_time
    current = Subscription.where(user: user).order(end_time: :desc).first
    start_time = current.present? ? current.end_time : Time.current
    self.start_time = start_time
    self.end_time = start_time + 1.month
  end
end
