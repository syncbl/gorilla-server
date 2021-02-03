class UserPolicy < ApplicationPolicy

  def show?
    user == record
  end

  def update?
    show?
  end

  def edit?
    show?
  end

end
