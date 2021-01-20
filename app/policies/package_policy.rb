class PackagePolicy < ApplicationPolicy
  def update?
    user.admin? or not record.published?
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    record.user.id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
