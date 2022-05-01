class PackagePolicy
  attr_reader :user, :package

  def initialize(user, package)
    @user = user
    @package = package
  end

  # TODO: Too dirty logic
  def show?
    @user&.can_view?(@package) || @package.published?
  end

  def update?
    @user.can_edit? @package
  end

  def edit?
    update?
  end

  def destroy?
    @user.owner? @package
  end

  def search?
    @package.published?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope.where(user: @user)
    end
  end
end
