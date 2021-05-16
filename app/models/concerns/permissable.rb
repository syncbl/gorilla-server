module Permissable
  extend ActiveSupport::Concern

  def is_owner?(object)
    object.user == self
  end

  def friendly?(object)
    friends.include?(object.user)
  end

  def can_view?(object)
    can_edit?(object) ||
      (object.user.subscription.paid? &&
       object.published? &&
       (friendly?(object) || object.product&.validated_at < Time.current))
  end

  def can_edit?(object)
    is_owner?(object) || maintained.include?(object)
  end
end
