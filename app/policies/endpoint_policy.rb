class EndpointPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    true
  end

  def update?
    show?
  end

  # TODO: Endpoint profile edit
  #def edit?
  #  update?
  #end

  def destroy?
    @user.is_owner? @record
  end

  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @user.endpoints
    end
  end
end
