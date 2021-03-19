class PackagePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    true
  end

  def create?
    true
    # TODO: Check license limits
  end

  def new?
    create?
  end

  def update?
    @user.is_owner?(@record)
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
      scope.active.allowed_for(@user)
    end
  end
end
