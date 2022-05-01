class ActualizedSettingsService < ApplicationService
  def initialize(endpoint, packages, timestamp)
    @endpoint = endpoint
    @settings = @endpoint.settings
    @packages = packages
    @timestamp = timestamp ? Time.zone.at(timestamp.to_i) : Time.zone.at(0)
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
    @settings.where(package: { type: "Package::Component" })
             .where.not(package: components).map do |s|
      @endpoint.notify_remove_package(s.package)
    end

    # Mark settings with users without subscription as inconsistent
    @settings.includes(package: [user: :plans])
             .map do |s|
      s.update(consistent: false, active: false) if s.active? && !s.package.user.plan.active?
      s.update(active: true) if !s.active? && s.package.user.plan.active?
    end

    # Only updated packages
    @settings.includes(:sources)
             .where(active: true)
             .where(
               consistent: true,
               package_id: @packages,
               sources: { published_at: @timestamp.. },
             ).or(
               where(
                 consistent: false,
                 package_id: @packages,
               )
             )

    # TODO: We can exclude packages from users without plan, but then
    # timestamp will increase and this updates will be lost. What we can do?
    # Perhaps, we should add flag for this settings and update if request was made
    # but plan was absent. Also we can do that is source request was in broken
    # order even if everything is ok.
  end
end
