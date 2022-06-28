class PackageInstallService < ApplicationService
  def initialize(endpoint, package)
    @endpoint = endpoint
    @package = package.is_a?(Package) ? package : Package.find(package)
  end

  def call
    Setting.find_or_create_by! endpoint: @endpoint, package: @package
  end
end
