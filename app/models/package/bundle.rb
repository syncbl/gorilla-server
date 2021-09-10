class Package::Bundle < Package
  include ParamAwareable

  jsonb_accessor :params,
                 external_url: [:string],
                 checksum: [:string],
                 switches: [:string],
                 uninstall: [:string]

  strip_attributes

  before_validation :set_type, on: :create

  default_scope -> {
                  with_package_type(:bundle)
                }

  def publishable?
    true
  end

  private

  def set_type
    self.package_type = :bundle
  end
end
