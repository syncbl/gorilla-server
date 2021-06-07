module Notifiable
  extend ActiveSupport::Concern

  def notify(scope, method, payload)
    Rails.cache.write "Notification_#{self.id}.#{SecureRandom.uuid}",
                      Hash["#{scope.downcase}:#{method.downcase}", payload],
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

  def notify_package_install(object)
    notify :package, :install, object.id
  end
end
