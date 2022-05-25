class ActualizedSettingsService < ApplicationService
  def initialize(endpoint, sources)
    @endpoint = endpoint
    # TODO: Settings from Source.Package.Setting.Endpoint
    # If empty - load everything
    @settings = @endpoint.settings
    @sources = sources
    @packages = @sources.map(&:package_id)
  end

  def call
    components = Set[]
    DependencyExtractService.call(@endpoint, @packages).map do |c|
      next if components.include?(c.dependent_package.id)

      components << c.dependent_package.id
      unless @packages.include?(c.dependent_package.id)
        @endpoint.notify_add_package(c.package.id, c.dependent_package.id)
      end
    end

    # Auto cleaning unused components
    # TODO: bundle must be set for component
    @settings.includes(:package).where(package: { type: "Package::Component" })
             .where.not(package: components).map do |s|
      @endpoint.notify_remove_package(s.package)
    end

    # Mark settings with users without subscription as inactive
    # TODO: !!! Transmit Source ID to skip installed sources !!!
    # We will get setting_id from it and chain the sources.
    # If first source's ancestor != source_id, then we will run full resync.
    # Timestamp will be deleted.

    # Only updated packages
    @settings.includes(:sources, :package)
             .where(package_id: @packages).select do |s|
      s.package.sources.map(&:id).in?(@sources)
      s.package.user.plans.active?
    end

    # TODO: We can exclude packages from users without plan, but then
    # timestamp will increase and this updates will be lost. What we can do?
    # Perhaps, we should add flag for this settings and update if request was made
    # but plan was absent. Also we can do that is source request was in broken
    # order even if everything is ok.
  end
end
