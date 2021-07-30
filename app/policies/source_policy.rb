class SourcePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    @user.can_view? @record
  end

  def create?
    @user.can_edit? @record
  end

  def update?
    @user.can_edit? @record
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def merge?
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
