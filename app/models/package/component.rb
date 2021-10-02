class Package::Component < Package
  include ParamAwareable

  has_many :packages, through: :dependencies

  before_destroy :check_dependency, prepend: true
  before_validation :set_type, on: :create

  default_scope { with_package_type(:component) }

  # TODO: Mark orphaned
  def orphaned?
    packages.size == 0
  end

  def publishable?
    true
  end

  private

  def set_type
    self.package_type = :component
  end

  def check_dependency
    unless orphaned?
      # TODO: Relative path to error
      errors.add :size, I18n.t("errors.attributes.package.dependency.used")
      throw :abort
    end
  end
end
