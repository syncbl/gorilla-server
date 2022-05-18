# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Package, blocked_at: nil
    cannot :read, Package, published_at: nil

    return if user.blank? || user.blocked?

    can :read, User
    can :update, User, id: user.id
    can :manage, Endpoint, user: user,
                           blocked_at: nil
    can :destroy, Endpoint, user: user
    can :manage, Package, user: user,
                          blocked_at: nil
    can :destroy, Package, user: user
    can :manage, Source,
        package: {
          user:,
          blocked_at: nil,
        },
        blocked_at: nil
    can :destroy, Source,
        package: {
          user:
        }
    can :manage, Setting,
        endpoint: {
          user:,
          blocked_at: nil
        },
        package: {
          blocked_at: nil
        }
    can :destroy, Setting,
        endpoint: {
          user:
        }
  end
end
