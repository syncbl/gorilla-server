module Notifiable
  extend ActiveSupport::Concern

  def notify(method, object, payload = nil)
    # Notifications can be one per object or one per activity in order to avoid spam
    value = object.is_a?(ApplicationRecord) ? object.id : object
    notification = Hash[method, value]
    notification[:message] = payload if payload
    deliver_notification "N_#{self.id}.#{method}.#{value}", notification
  end

  # TODO: Payload must be text only
  def notifications
    messages = Set[]
    redis_pool.with do |redis|
      redis.scan_each(match: "N_#{self.id}.*") do |key|
        value = redis.hgetall(key)
        messages << value if validate_notification(value)
        redis.del(key)
      end
    end
    messages.to_a
  end

  private

  def redis_pool
    @redis_pool ||= Api::Redis.new.pool
  end

  def deliver_notification(key, value)
    if validate_notification(value)
      redis_pool.with do |redis|
        redis.mapped_hmset key, value
        redis.expire key, NOTIFICATION_EXPIRES_IN
      end
    end
  end

  def validate_notification(payload)
    payload.size > 0 && %w[add_package remove_package flash_alert flash_notice]
      .include?(payload.keys[0])
  end
end
