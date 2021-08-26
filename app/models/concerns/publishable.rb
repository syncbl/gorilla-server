module Publishable
  extend ActiveSupport::Concern

  LOCKED_FIELDS = %w[params file external_url checksum switches uninstall]

  def self.included(base)
    base.class_eval {
      validate :try_check_publishable, if: :published_at_changed?
      validate :lock_published, unless: :published_at_changed?

      scope :published, -> {
              where(self.arel_table[:published_at].lt(Time.current))
            }
    }
  end

  def publish!(time = Time.current)
    update!(published_at: time)
    action_log
  end

  def unpublish!
    update!(published_at: nil)
    action_log
  end

  def published?
    published_at.present? && user.subscriptions.extended?
  end

  private

  def try_check_publishable
    if published_at.present? && self.respond_to?(:publishable?) && !self.send(:publishable?)
      errors.add :published_at, I18n.t("errors.messages.cannot_publish") # TODO: Edit i18n
    end
  end

  def lock_published
    if published_at.present? && (changed & LOCKED_FIELDS).size > 0
      errors.add :published_at, I18n.t("errors.messages.locked_published")
    end
  end
end
