module Notifiable
  extend ActiveSupport::Concern
  require "redis"

  def notify_object(method, object)
    # Notifications can be one per object or one per activity in order to avoid spam
    deliver_notification "N_#{self.id}.#{object.id}", Hash[method, object.id]
  end

  def notifications
    messages = Set[]
    redis_connection.scan_each(match: "N_#{self.id}.*") do |key|
      messages << redis_connection.hgetall(key)
      redis_connection.del(key)
    end
    messages.to_a
  end

  private

  def redis_connection
    @redis_connection ||= Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" })
  end

  def deliver_notification(key, value)
    redis_connection.mapped_hmset key, value
    redis_connection.expire key, NOTIFICATION_EXPIRES_IN
  end
end
