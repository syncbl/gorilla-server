class ActualizedSettingsService < ApplicationService
  def initialize(endpoint, sources)
    @endpoint = endpoint
    # TODO: Settings from Source.Package.Setting.Endpoint
    # If empty - load everything
    @settings = @endpoint.settings
    @sources = sources
    @package_ids = @sources.map(&:package_id)
  end

  # TODO: !!! 1. Get all the sources with ids.
  # 2. Get all the sources per package which is newer than in a recordset from #1.
  # We need to do that with no more than 2-3 queries.

  def call
    components = Set[]
    DependencyExtractService.call(@endpoint, @package_ids).map do |c|
      components << c.dependent_package_id
      next if @package_ids.include?(c.dependent_package_id)

      # TODO: Notify if optional, but somehow we need to
      # make this notifications only once
      @endpoint.notify_add_package(c.package_id, c.dependent_package_id)
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
    # TODO: & endpoint.packages.pluck(:id) - but better check every source
    # In that case do that first before everything else
    @settings.includes(:sources, :package)
             .where(package_id: @package_ids).select do |s|
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
