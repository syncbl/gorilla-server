module Publishable
  extend ActiveSupport::Concern

  LOCKED_FIELDS = %w[file].freeze

  def self.included(base)
    base.class_eval do
      has_event :publish

      validate :try_check_publishable, if: :published_at_changed?
      validate :lock_published, unless: :published_at_changed?
    end
  end

  def publish!(time = Time.current)
    update!(published_at: time)
  end

  def published?
    super && user.plans.active?
  end

  private

  # TODO: After load from db class will be Package and error will raise
  def try_check_publishable
    return unless published_at.present? &&
                  respond_to?(:publishable?) &&
                  !send(:publishable?)

    errors.add :published_at, I18n.t("errors.messages.cannot_publish")
  end

  def lock_published
    return unless published_at.present? &&
                  (changed & LOCKED_FIELDS).size.positive?

    errors.add :published_at, I18n.t("errors.messages.locked_published")
  end
end
