class ActualizedSettingsQuery < ApplicationQuery
  def initialize(endpoint, packages, timestamp)
    @endpoint = endpoint
    @settings = @endpoint.settings
    @packages = packages
    @timestamp = timestamp ? Time.zone.at(timestamp.to_i) : Time.zone.at(0)
  end

  def call
    components = Set[]
    DependencyExtractQuery.call(@endpoint, @packages).map do |c|
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

    # Only updated packages
    @settings.includes(:sources)
             .where(package_id: @packages, sources: { published_at: @timestamp.. })
  end
end
