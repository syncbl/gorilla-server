module Permissable
  extend ActiveSupport::Concern

  def is_owner?(object)
    object.user == self
  end

  def is_maintainer?(object)
    object.maintainers.include?(self)
  end

  def can_edit?(object)
    is_owner?(object) || is_maintainer?(object)
  end

  def can_view?(object)
    can_edit?(object) || object.published?
  end
end
