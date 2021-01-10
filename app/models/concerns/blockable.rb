module Blockable
  extend ActiveSupport::Concern

  # TODO: Add logger

  def block!(reason = nil)
    self.blocked_at = Time.current
    self.block_reason = reason
    self.save!
    Rails.cache.delete_if {|k, v| k.end_with? id }
  end

  def unblock!
    self.blocked_at = nil
    self.block_reason = nil
    self.save!
  end

  def blocked?
    blocked_at != nil
  end

  def self.included(base)
    base.class_eval { scope :active, lambda { where(blocked_at: nil) } }
  end
end
