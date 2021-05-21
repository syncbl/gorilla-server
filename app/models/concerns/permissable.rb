module Permissable
  extend ActiveSupport::Concern

  def is_owner?(object)
    object.user == self
  end

  def can_use?(object)
    can_view?(object) || object.is_component
  end

  def can_view?(object)
    can_edit?(object) ||
      # TODO: object.user.subscription.paid? &&
        (object.published? || object.product&.validated_at < Time.current)
  end

  def can_edit?(object)
    is_owner?(object) || maintained.include?(object)
  end
end
