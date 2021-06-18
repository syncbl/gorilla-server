class Package::Default < Package
  before_save :set_package
  before_validation :set_type, on: :create

  validates :is_component, inclusion: [false]

  default_scope -> {
                  where(is_component: false)
                }

  private

  def set_type
    self.package_type = :default
  end

  def set_package
    self.is_component = false
  end
end
