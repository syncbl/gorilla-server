class PackageInstallService < ApplicationService
  def initialize(packages, endpoint)
    @packages = packages
    @endpoint = endpoint
  end

  def call
    settings = Set[]
    @packages.each do |package|
      setting = Setting.find_or_initialize_by(endpoint: @endpoint, package:)
      setting.save
      settings << setting
    end
    settings
  end
end
