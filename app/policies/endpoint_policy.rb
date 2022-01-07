class EndpointPolicy
  include ApplicationHelper

  attr_reader :endpoint, :record

  def initialize(endpoint, record)
    @endpoint = endpoint
    @record = record
  end

  def show?
    @endpoint.user&.owner?(@record)
  end

  def update?
    show?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope
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
