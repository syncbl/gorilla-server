class Package::Component < Package::Internal
  has_many :packages, through: :dependencies

  jsonb_accessor :params,
                 path: [:string, default: ""]

  before_destroy :check_dependency, prepend: true

  default_scope { with_package_type(:component) }

  # TODO: Mark orphaned
  def orphaned?
    packages.size.zero?
  end

  private

  def set_type
    self.package_type = :component
  end

  def check_dependency
    unless orphaned?
      # TODO: Relative path to error
      errors.add :size, I18n.t("errors.attributes.dependency.used")
      throw :abort
    end
  end
end
