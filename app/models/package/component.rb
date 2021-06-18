class Package::Component < Package
  has_many :packages, through: :dependencies

  before_save :set_package
  before_destroy :check_dependency, prepend: true
  before_validation :set_type, on: :create

  validates :is_component, inclusion: [true]

  default_scope -> {
                  where(is_component: true)
                }

  # TODO: Destroy orphaned components. Try dependent: :destroy like in activestorage

  def self.extract(package, components = Set[])
    package.dependencies
      .select { |d| !components.include?(d.component) && d.required_component? }
      .map do |d|
      components << d
      self.extract(d.component, components)
    end
    components.to_a.reverse
  end

  def orphaned?
    packages.size == 0
  end

  private

  def set_type
    self.package_type = :component
  end

  def set_package
    self.is_component = true
  end

  def check_dependency
    unless orphaned?
      # TODO: Relative path to error
      errors.add I18n.t("errors.attributes.package.dependency.used")
      throw :abort
    end
  end
end
