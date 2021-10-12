class EndpointPolicy
  include ApplicationHelper

  attr_reader :endpoint, :record

  def initialize(endpoint, record)
    @endpoint = endpoint
    @record = record
  end

  def show?
    @endpoint == current_endpoint || @endpoint.user&.is_owner?(@record)
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

    def initialize(endpoint, scope)
      @endpoint = endpoint
      @scope = scope
    end

    def resolve
      @endpoint.user.endpoints
    end
  end
end
