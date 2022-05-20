module Publishable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      has_event :publish

      validate :validate_publishable, if: :published_at_changed?

      def publish!
        validate_publishable
        super
      end
    end
  end

  private

  def validate_publishable
    return if respond_to?(:publishable?) && send(:publishable?)

    errors.add :published_at, I18n.t("errors.messages.cannot_publish")
  end
end
