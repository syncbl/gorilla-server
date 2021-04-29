module Publishable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval {
      validate :check_publishable

      scope :published, -> {
        where(self.arel_table[:published_at].lt(Time.current))
      }
    }
  end

  private

  def check_publishable
    if published_at.present?
      errors.add(I18n.t('model.package.error.cannot_publish')) unless validated?
    end
  end
end
