class Package::Bundle < Package
  include ParamAwareable

  before_validation :set_type, on: :create

  default_scope -> {
                  with_package_type(:bundle)
                }

  private

  def set_type
    self.package_type = :bundle
  end
end
