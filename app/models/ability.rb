# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Package, blocked_at: nil
    cannot :read, Package, published_at: nil

    return if user.blank?

    if user.blocked?
      can :destroy, Endpoint, user: user
      can :destroy, Package, user: user
      can :destroy, Source,
        package: {
          user: user,
        }
      can :destroy, Setting,
        endpoint: {
          user: user,
        }
    else
      can :read, User
      can :update, User, id: user.id
      can :manage, Endpoint, user: user
      can :manage, Package, user: user
      can :manage, Source,
          package: {
            user: user,
          }
      can :manage, Setting,
          endpoint: {
            user: user,
          }
    end
  end
end
