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
    @user.is_owner?(@record)
  end

  # TODO: Endpoint profile edit
  #def edit?
  #  update?
  #end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.endpoints
    end
  end
end
