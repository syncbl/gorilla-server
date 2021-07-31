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
    update?
  end

  def merge?
    update?
  end
end
