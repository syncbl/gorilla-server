class Package::Trusted < Package::Bundle
  # This class is used for bundles with API access, like own applications and services
  # TODO: package owner must be trusted too.

  default_scope { with_package_type(:trusted) }

  private

  def set_type
    self.package_type = :trusted
  end
end
