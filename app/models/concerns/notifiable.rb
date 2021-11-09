module Notifiable
  extend ActiveSupport::Concern

  def notify(method, object, message = nil)
    # Notifications can be one per object or one per activity in order to avoid spam
    value = object.is_a?(ApplicationRecord) ? object.id : object
    notification = Hash[method.to_s, value]
    notification[:message] = message if message
    if Push::Server.online?(value)
      Push::Server.new.notify(value, notification)
    else
      deliver_notification "N_#{self.id}.#{method}.#{value}", notification
    end
  end

  def notifications(only:)
    messages = Set[]
    notification_pool.with do |redis|
      redis.scan_each(match: "N_#{self.id}.*") do |key|
        value = redis.hgetall(key)
        if validate_notification(value)
          if !only.is_a?(Array) || value.keys[0].in?(only)
            messages << value
            redis.del(key)
          end
        else
          raise "Outgoing notification is invalid!"
        end
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

  # TODO: Noticed gem and make redis just a transport component
  def validate_notification(payload)
    payload.size > 0 &&
      (payload[:message].nil? || payload[:message].is_a?(String)) &&
      ((self.is_a?(Endpoint) && payload.keys[0].in?(ENDPOINT_NOTIFICATIONS)) ||
       (self.is_a?(User) && payload.keys[0].in?(USER_NOTIFICATIONS)))
  end
end
