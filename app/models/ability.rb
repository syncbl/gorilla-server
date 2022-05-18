# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Package, blocked_at: nil
    cannot :read, Package, published_at: nil

    return if user.blank? || user.blocked?

    can :read, User
    can :update, User, id: user.id
    can :manage, Endpoint, user:,
                           blocked_at: nil
    can :manage, Package, user:,
                          blocked_at: nil
    can :manage, Source,
        package: {
          user:,
          blocked_at: nil,
        },
        blocked_at: nil
    can :manage, Setting,
        package: {
          user:,
          blocked_at: nil,
        }
  end
end
