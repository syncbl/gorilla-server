module ModelBlocker

  def block!(reason = nil)
    self.blocked_at = Time.current
    self.block_reason = reason
    self.save!
  end

  def unblock!
    self.blocked_at = nil
    self.block_reason = nil
    self.save!
  end

  def self.included(base)
    base.class_eval do
      scope :active, lambda { where(blocked_at: nil) }
    end
  end

end