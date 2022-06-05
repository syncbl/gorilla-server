class PackageInstallService < ApplicationService
  def initialize(endpoint, package)
    @endpoint = endpoint
    @package = package
  end

  def call
    # TODO: Add check of ancestors installed at least for components
    package = if @package.is_a? Package
      @package
    else
      Package.find(@package)
    end
    Setting.find_or_create_by(endpoint: @endpoint, package:)
  end
end
