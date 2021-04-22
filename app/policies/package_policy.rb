class PackagePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    @user.can_view_package? @record
  end

  def create?
    true
    # TODO: Check license limits
  end

  def new?
    create?
  end

  def update?
    @user.is_owner? @record
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
