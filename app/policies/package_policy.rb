class PackagePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    @user.can_view? @record
  end

  def update?
    @user.can_edit? @record
  end

  def edit?
    update?
  end

  def destroy?
    @user.owner? @record
  end

  def search?
    user&.can_view?(@record) || @record.product.nil?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @user.packages
    end
  end
end
