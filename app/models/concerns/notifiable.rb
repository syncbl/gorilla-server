module Notifiable
  extend ActiveSupport::Concern

  def notify(method, value)
    # Notifications can be one per object or one per activity in order to avoid spam
    if value.is_a? ApplicationRecord
      payload = value.id
      name = "Notification_#{self.id}.#{payload}"
    else
      payload = value
      name = "Notification_#{self.id}.#{method}"
    end
    Rails.cache.write name,
                      Hash["#{method}", payload],
                      expires_in: NOTIFICATION_EXPIRES_IN
  end

  def notifications
    messages = Set[]
    Rails.cache.redis.scan_each(match: "Notification_#{self.id}.*") do |key|
      messages << Rails.cache.read(key)
      Rails.cache.redis.del(key)
    end
    messages.to_a
  end
end
