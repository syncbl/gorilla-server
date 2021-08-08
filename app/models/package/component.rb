class Package::Component < Package
  include ParamAwareable

  has_many :packages, through: :dependencies

  before_destroy :check_dependency, prepend: true
  before_validation :set_type, on: :create

  validates :is_component, inclusion: [true]
  validates :is_external, inclusion: [false]

  default_scope -> {
                  where(is_component: true)
                }

  # TODO: Destroy orphaned components. Try dependent: :destroy like in activestorage

  def self.extract(package, components = Set[])
    package.dependencies.map do |d|
      components << d if d.required_component?
      self.extract(d.dependent_package, components)
    end
    components.to_a.reverse
  end

  def orphaned?
    packages.size == 0
  end

  private

  def set_type
    self.package_type = :component
    self.is_component = true
    self.is_external = false
  end

  def check_dependency
    unless orphaned?
      # TODO: Relative path to error
      errors.add I18n.t("errors.attributes.package.dependency.used")
      throw :abort
    end
  end
end
