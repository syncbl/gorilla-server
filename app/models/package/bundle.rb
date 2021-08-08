class Package::Bundle < Package
  include ParamAwareable

  before_validation :set_type, on: :create

  validates :is_component, inclusion: [false]
  validates :is_external, inclusion: [false]

  default_scope -> {
                  where(is_component: false)
                }

  private

  def set_type
    self.package_type = :bundle
    self.is_component = false
    self.is_external = false
  end

end
