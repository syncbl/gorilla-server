class ActualizedSettingsService < ApplicationService
  def initialize(settings)
    @settings = settings
  end

  def call
    # TODO: Replace discard with events
    discard_packages = Set[]
    install_packages = Set[]
    @settings.map do |setting|
      if setting.replaced?
        # TODO: Add upgrade strategy
        setting.discard
        discard_packages << setting.package
        install_packages << setting.package.replaced_by
      end
    end
    @settings.map do |setting|
      if setting.discarded?
        setting.package.all_components(discard_packages)
      else
        setting.package.all_components(install_packages)
      end
    end
    @settings.map do |setting|
      if setting.kept? && discard_packages.include?(setting.package)
        setting.discard
      elsif install_packages.include?(setting.package)
        setting.undiscard
        install_packages.delete(setting.package)
      end
    end
    install_packages.each { |p| @settings.create(package: p) }
    @settings #.reload
  end
end
