module Permissable
  extend ActiveSupport::Concern

  # TODO: Add purchasing feature and rules

  def owner?(object)
    object.user == self
  end

  def can_edit?(object)
    owner?(object)
  end

  def can_view?(object)
    object.published? || can_edit?(object)
  end
end
