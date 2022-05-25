class PackageInstallService < ApplicationService
  def initialize(endpoint, packages)
    @endpoint = endpoint
    @packages = packages
  end

  def call
    # TODO: Add check of ancestors installed at least for components
    settings = Set[]
    @packages.each do |package|
      Setting.find_or_create_by(endpoint: @endpoint, package:) do |s|
        # TODO: Touch?
        settings << s
      end
    end
    settings
  end
end
