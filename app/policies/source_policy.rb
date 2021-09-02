class SourcePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    @user.can_view? @record.package
  end

  def create?
    @user.can_edit? @record.package
  end

  def update?
    @user.can_edit? @record.package
  end

  def edit?
    update?
  end

  def destroy?
    @user.is_owner? @record
  end

  def merge?
    destroy?
  end
end
