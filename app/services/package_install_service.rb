class PackageInstallService < ApplicationService
  def initialize(endpoint, packages)
    @endpoint = endpoint
    @packages = packages
  end

  def call
    return [] unless @packages.any?

    settings = Set[]
    Setting.transaction do
      @packages.each do |package|
        settings << Setting.find_or_create_by!(endpoint: @endpoint, package: package)
      end
    end
    settings
  end
end
