module Notifiable
  extend ActiveSupport::Concern

  def notify(method, object, message = nil)
    # Notifications can be one per object or one per activity in order to avoid spam
    object_id = object.is_a?(ApplicationRecord) ? object.id : object
    notification = { method.to_s => object_id }
    notification[:message] = message if message
    raise "Incoming notification is invalid!" unless validate_notification(notification)

    if online?
      # Send notification
    else
      store_notification(notification)
    end
  end

  def online?
    # TODO: Push::Server.online?(self.id) && Push::Server.enqueue(self.id, notification)
    false
  end

  def notifications(only:)
    messages = Set[]
    Api::Redis.pool.with do |redis|
      redis.scan_each(match: "N_#{id}.*") do |key|
        notification = redis.hgetall(key)
        raise "Outgoing notification is invalid!" unless validate_notification(notification)

        if !only.is_a?(Array) || notification.keys[0].in?(only)
          messages << notification
          redis.del(key)
        end
      end
    end
    messages.to_a
  end

  def notify_add_package(package, dependent_package = nil)
    if dependent_package.nil?
      notify :add_package, package.to_s
    else
      notify :add_package, "#{package}/#{dependent_package}"
    end
  end

  def notify_remove_package(package)
    notify :remove_package, package
  end

  private

  def store_notification(value)
    method, object_id = value.first
    key = "N_#{id}.#{method}.#{object_id}"
    Api::Redis.pool.with do |redis|
      redis.mapped_hmset key, value
      redis.expire key, NOTIFICATION_EXPIRES_IN
    end
  end

  # TODO: Noticed gem and make redis just a transport component
  def validate_notification(payload)
    payload.size.positive? &&
      (payload[:message].nil? || payload[:message].is_a?(String)) &&
      ((is_a?(Endpoint) && payload.keys[0].in?(ENDPOINT_NOTIFICATIONS)) ||
       (is_a?(User) && payload.keys[0].in?(USER_NOTIFICATIONS)))
  end
end
