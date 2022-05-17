# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Package, blocked_at: nil
    cannot :read, Package, published_at: nil

    return if user.blank? || user.blocked?

    can :read, User
    can :update, User, user: user
    can :manage, Package, user: user, blocked_at: nil
    can :manage, Source, user: user
    can :manage, Setting, user:
  end
end
