module Blockable
  extend ActiveSupport::Concern

  # TODO: Add logger

  def block!(reason = nil)
    update!({
      blocked_at: Time.current,
      block_reason: reason
    })
    delete_cached
  end

  def unblock!
    update!({
      blocked_at: nil,
      block_reason: nil
    })
  end

  def blocked?
    blocked_at != nil
  end

  def self.included(base)
    base.class_eval { scope :active, lambda { where(blocked_at: nil) } }
  end

  def delete_cached
    Rails.cache.delete_matched("#{self.class.name}_#{id}")
  end
end
