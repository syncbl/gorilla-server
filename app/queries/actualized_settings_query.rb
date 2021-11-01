class ActualizedSettingsQuery < ApplicationQuery
  def initialize(endpoint, packages, timestamp)
    @endpoint = endpoint
    @settings = endpoint.settings
    @packages = packages
    @timestamp = timestamp ? Time.at(timestamp.to_i) : Time.at(0)
  end

  def call
    components = Set[]
    DependencyExtractQuery.call(@endpoint, @packages).map do |c|
      next if components.include?(c.dependent_package.id)
      components << c.dependent_package.id
      unless @settings.exists?(package: c.dependent_package)
        @endpoint.notify :add_component, "#{c.dependent_package.id}:#{c.package.id}"
      end
    end

    # Auto cleaning unused components
    @settings.where(package: { package_type: :component })
      .where.not(package: components).map do |s|
      @endpoint.notify :remove_package, s.package
    end

    # Only updated packages
    @settings.includes(:sources).where(Source.arel_table[:created_at].gt(@timestamp)).uniq
  end
end
