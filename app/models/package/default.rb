class Package::Default < Package
  before_save :set_component

  validates :is_component, inclusion: [false]

  default_scope -> {
                  where(is_component: false)
                }

  protected

  def set_component
    self.is_component = false
  end
end
