module Permissable
  extend ActiveSupport::Concern

  def is_owner?(object)
    object.user == self
  end

  def is_maintainer?(object)
    object.maintainers.include?(self)
  end

  def can_edit?(object)
    subscriptions.paid? &&
      (is_owner?(object) || is_maintainer?(object))
  end

  def can_view?(object)
    can_edit?(object) ||
      ((object.published? || object.is_component) &&
       object.user.subscriptions.extended?)
  end
end
