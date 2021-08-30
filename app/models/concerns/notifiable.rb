module Notifiable
  extend ActiveSupport::Concern

  def notify(method, object)
    # Notifications can be one per object or one per activity in order to avoid spam
    notification = object.is_a?(ApplicationRecord) ? object.id : object
    deliver_notification "N_#{self.id}.#{notification}", Hash[method, notification]
  end

  def notifications
    messages = Set[]
    redis_connection.with do |redis|
      redis.scan_each(match: "N_#{self.id}.*") d-=5o |key|
        value = redis.hgetall(key)
        messages << value if validate_notification(key, value)
        redis.del(key)
      end
    end
    messages.to_a
  end

  private

  def redis_connection
    @redis_connection ||= Api::Redis.new.pool
  end

  def deliver_notification(key, value)
    if validate_notification(key, value)
      redis_connection.with do |redis|
        redis.mapped_hmset key, value
        redis.expire key, NOTIFICATION_EXPIRES_IN
      end
    end
  end

  def validate_notification(key, value)
    %i[add_package remove_package].include?(key) && value.size > 0
  end
end
