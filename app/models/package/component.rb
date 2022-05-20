class Package::Component < Package::Internal
  has_many :packages, through: :dependencies

  before_destroy :check_dependency, prepend: true

  def self.model_name
    Package.model_name
  end

  def orphaned?
    Dependency.where(dependent_package: self).empty?
  end

  private

  def check_dependency
    return if orphaned?

    # TODO: Relative path to error
    errors.add :size, I18n.t("errors.attributes.dependency.used")
    throw :abort
  end
end
