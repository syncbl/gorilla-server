class Package::Component < Package
  has_many :packages, through: :dependencies

  before_save :set_component
  before_destroy :check_dependency, prepend: true

  validates :is_component, inclusion: [true]

  default_scope -> {
                  where(is_component: true)
                }

  # TODO: Destroy orphaned components. Try dependent: :destroy like in activestorage

  def self.extract(package, components = Set[])
    package.dependencies
      .select { |d| !components.include?(d.component) && !d.component.is_optional }
      .map do |d|
      components << d.component
      self.extract(d.component, components)
    end
    components.to_a.reverse
  end

  protected

  def set_component
    self.is_component = true
  end

  def check_dependency
    if packages.size > 0
      # TODO: Relative path to error
      errors.add I18n.t("errors.attributes.package.component_used")
      throw :abort
    end
  end
end
