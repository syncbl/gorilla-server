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
      scope :except_blocked, -> {
              where(blocked_at: nil)
            }
    }
  end
end
