class ActualizedSettingsService < ApplicationService
  def initialize(settings)
    @settings = settings
    #@user = @settings.first&.endpoint.user
  end

  def call
    # TODO: Replace discard with events
    # TODO: Replace with stored proc

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
        discard_packages = setting.package.get_components
      else
        install_packages = setting.package.get_components
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
    install_packages.each do |p|
      if !p.is_optional?
        @settings.create(package: p)
      end
    end
    @settings
  end
end
