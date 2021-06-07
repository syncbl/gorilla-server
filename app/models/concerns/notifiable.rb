module Notifiable
  extend ActiveSupport::Concern

  def notify(method, payload)
    Rails.cache.write "Notification_#{self.id}.#{SecureRandom.uuid}",
                      Hash["#{method.downcase}", payload],
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
