module Blockable
  extend ActiveSupport::Concern

  def block!(reason = nil)
    update!({
      blocked_at: Time.current,
      block_reason: reason,
    })
    action_log
  end

  def unblock!
    update!({
      blocked_at: nil,
      block_reason: nil,
    })
    action_log
  end

  def blocked?
    blocked_at != nil
  end

  def self.included(base)
    base.class_eval {
      after_save :clear_cache

      scope :except_blocked, -> {
              where(blocked_at: nil)
            }
    }
  end

  private

  def clear_cache
    Rails.cache.delete_matched("#{self.class.name}_#{id}")
  end
end
