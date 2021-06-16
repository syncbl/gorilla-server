class Package::Default < Package
  before_save :set_package

  validates :is_component, inclusion: [false]

  default_scope -> {
                  where(is_component: false)
                }

  protected

  def set_package
    self.is_component = false
  end
end
