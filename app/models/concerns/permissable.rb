module Permissable
  extend ActiveSupport::Concern

  def is_owner?(object)
    object.user == self
  end

  def can_edit?(object)
    is_owner?(object) || maintained.include?(object)
  end

  def can_view?(object)
    can_edit?(object) ||
      (object.published? && subscriptions.extended?)
  end

  def can_use?(object)
    can_view?(object) || object.is_component
  end
end
