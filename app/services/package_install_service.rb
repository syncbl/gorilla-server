class PackageInstallService < ApplicationService
  def initialize(package, endpoint)
    @package = package
    @endpoint = endpoint
  end

  # TODO: If query is not from API then notify endpoint
  def call
    @endpoint.settings.find_or_initialize_by(package: @package)
  end
end
