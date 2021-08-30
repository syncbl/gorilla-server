module Notifiable
  extend ActiveSupport::Concern
  require "redis"
  require "connection_pool"

  def notify_object(method, object)
    # Notifications can be one per object or one per activity in order to avoid spam
    deliver_notification "N_#{self.id}.#{object.id}", Hash[method, object.id]
  end

  def notifications
    messages = Set[]
    redis_pool.with do |redis|
      redis.scan_each(match: "N_#{self.id}.*") do |key|
        messages << redis.hgetall(key)
        redis.del(key)
      end
    end
    messages.to_a
  end

  private

  def redis_pool
    @redis_pool ||= ConnectionPool.new(size: ActiveRecord::Base.connection_pool.db_config.pool) do
      Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" })
    end
  end

  def deliver_notification(key, value)
    redis_pool.with do |redis|
      redis.mapped_hmset key, value
      redis.expire key, NOTIFICATION_EXPIRES_IN
    end
  end
end
