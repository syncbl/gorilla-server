class PackagePolicy
  attr_reader :user, :package

  def initialize(user, package)
    @user = user
    @package = package
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    perm_user_only!
  end

  def new?
    create?
  end

  def update?
    perm_edit!
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
      if user.nil?
        scope.kept.where(trusted: true).includes([:icon_attachment])
      else
        scope.kept.where(user: user, trusted: false).or(where(trusted: true)).includes([:icon_attachment])
      end
    end
  end

  private

  def perm_user_only!
    @user.endpoint.nil?
  end

  def perm_edit!
    perm_user_only! && (@package.user.id == @user.id)
  end

end
