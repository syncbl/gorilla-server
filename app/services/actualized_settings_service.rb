class ActualizedSettingsService < ApplicationService
  def initialize(endpoint, source_ids)
    @endpoint = endpoint
    @settings = @endpoint.settings
    @sources = Source.where(id: source_ids)
    @packages = Package.includes(
      sources: { file_attachment: :blob },
      user: :plans
    ).where(sources: @sources)
    @updated_packages = @packages.where(sources: { ancestor: @sources })
  end

  # TODO: !!! 1. Get all the sources with ids.
  # 2. Get all the sources per package which is newer than in a recordset from #1.
  # We need to do that with no more than 2-3 queries.

  def call
    components = Set[]
    DependencyExtractService.call(@endpoint, @packages).map do |c|
      components << c.dependent_package_id
      next if @packages.include?(c.dependent_package)

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
    updated_sources = []
    @updated_packages.each do |p|
      p.sources.each do |s|
        if s.ancestor.in?(@sources) && s.package.user.plans.active?
          updated_sources << p.sources.where(created_at: s.created_at..)
          break
        end
      end
    end
    updated_sources.flatten
  end
end
