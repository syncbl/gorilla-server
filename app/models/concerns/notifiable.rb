module Notifiable
  extend ActiveSupport::Concern

  def notify(method, object)
    Rails.cache.write "Notification_#{self.id}.#{SecureRandom.uuid}",
                      Hash[method.downcase, object.id],
                      expires_in: NOTIFICATION_EXPIRES_IN
  end

  def notifications
    messages = Set[]
    Rails.cache.redis.scan_each(match: "Notification_#{self.id}.*") do |key|
      if message = Rails.cache.read key
        messages << message
        Rails.cache.redis.del key
      end
    end
    messages
  end
end
