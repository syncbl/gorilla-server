class PackagePolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    record.published || update?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    is_owner?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.allowed_for(user)
    end
  end

  private

  def is_owner?
    record.user.id == user.id
  end

end
