module Publishable
  extend ActiveSupport::Concern

  LOCKED_FIELDS = %w[file].freeze

  def self.included(base)
    base.class_eval {
      has_event :publish

      validate :try_check_publishable, if: :published_at_changed?
      validate :lock_published, unless: :published_at_changed?
    }
  end

  def publish!(time = Time.current)
    update!(published_at: time)
  end

  def published?
    super && user.subscriptions.active?
  end

  private

  def try_check_publishable
    if published_at.present? && respond_to?(:publishable?) && !send(:publishable?)
      errors.add :published_at, I18n.t("errors.messages.cannot_publish")
    end
  end

  def lock_published
    if published_at.present? && (changed & LOCKED_FIELDS).size.positive?
      errors.add :published_at, I18n.t("errors.messages.locked_published")
    end
  end
end
