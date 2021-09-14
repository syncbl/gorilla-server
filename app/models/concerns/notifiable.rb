module Notifiable
  extend ActiveSupport::Concern

  def notify(method, object, message = nil)
    # Notifications can be one per object or one per activity in order to avoid spam
    value = object.is_a?(ApplicationRecord) ? object.id : object
    notification = Hash[method.to_s, value]
    notification[:message] = message if message
    deliver_notification "N_#{self.id}.#{method}.#{value}", notification
  end

  def notifications
    messages = Set[]
    notification_pool.with do |redis|
      redis.scan_each(match: "N_#{self.id}.*") do |key|
        value = redis.hgetall(key)
        if validate_notification(value)
          messages << value
        else
          raise "Outgoing notification is invalid!"
        end
        redis.del(key)
      end
    end
    messages.to_a
  end

  private

  def notification_pool
    @notification_pool ||= Api::Redis.new.pool
  end

  def deliver_notification(key, value)
    if validate_notification(value)
      notification_pool.with do |redis|
        redis.mapped_hmset key, value
        redis.expire key, NOTIFICATION_EXPIRES_IN
      end
    else
      raise "Incoming notification is invalid!"
    end
  end

  def validate_notification(payload)
    payload.size > 0 && %w[add_package remove_package remove_source
                           flash_alert flash_notice]
      .include?(payload.keys[0]) && (payload[:message].nil? || payload[:message].is_a?(String))
  end
end
