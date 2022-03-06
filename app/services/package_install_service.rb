class PackageInstallService < ApplicationService
  def initialize(package, endpoint)
    @package = package
    @endpoint = endpoint
  end

  # TODO: If query is not from API then notify endpoint
  def call
    @setting = @endpoint.settings.find_or_initialize_by(package: @package)
    @setting.save
    @setting
  end
end
