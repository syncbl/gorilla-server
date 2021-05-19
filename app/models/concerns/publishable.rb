module Publishable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval {
      validate :check_publishable

      scope :published, -> {
              where(self.arel_table[:published_at].lt(Time.current))
            }
    }
  end

  def publish!(time = Time.current)
    update!(published_at: time)
    action_log
  end

  def unpublish!
    update!(published_at: nil)
    action_log
  end

  def validate!
    update!(validated_at: Time.current)
    action_log
  end

  def invalidate!
    update!(validated_at: nil, published_at: nil)
    action_log
  end

  private

  def check_publishable
    if published_at.present?
      errors.add(I18n.t("errors.messages.cannot_publish")) unless validated?
    end
  end
end
