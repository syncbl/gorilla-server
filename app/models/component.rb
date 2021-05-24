class Component < Package
  before_save :set_component

  default_scope -> {
    where(is_component: true)
  }

  def self.extract(package, packages = Set[])
    package.dependencies.map do |p|
      packages << p.component
      self.extract(p.component, packages)
    end
    packages.to_a.reverse
  end

  protected

  def set_component
    self.is_component = true
  end
end
