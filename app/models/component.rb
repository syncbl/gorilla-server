class Component < Package
  before_save :set_component

  validates :is_component, inclusion: [true]

  default_scope -> {
                  where(is_component: true)
                }

  def self.extract(package, components = Set[])
    package.dependencies.select { |d| !components.include?(d.component) }
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
end
