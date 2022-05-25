# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, User
    can :read, Package, blocked_at: nil
    cannot :read, Package, published_at: nil

    return if user.blank?

    if user.blocked?
      can :destroy, Endpoint, user: user
      can :destroy, Package, user: user
      can :destroy, Source,
          package: {
            user:,
          }
      can :destroy, Setting,
          endpoint: {
            user:,
          }
    else
      can :update, User, id: user.id
      can :manage, Endpoint, user: user
      can :manage, Package, user: user
      can :manage, Source,
          package: {
            user:,
          }
      can :manage, Setting,
          endpoint: {
            user:,
          }
    end
  end
end
