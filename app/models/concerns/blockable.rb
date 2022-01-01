module Blockable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval {
      has_event :block
    }
  end

  def block!(reason = nil)
    update!(
      {
        blocked_at: Time.current,
        block_reason: reason,
      }
    )
  end

  def unblock!
    update!(
      {
        blocked_at: nil,
        block_reason: nil,
      }
    )
  end
end
