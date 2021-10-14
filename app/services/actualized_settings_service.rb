class ActualizedSettingsService < ApplicationService
  def initialize(endpoint, timestamp)
    @endpoint = endpoint
    @settings = endpoint.settings
    @timestamp = timestamp ? Time.at(timestamp.to_i) : Time.at(0)
  end

  def call
    components = Set[]
    DependencyExtractQuery.call(@endpoint).map do |c|
      next if components.include?(c.dependent_package.id)
      components << c.dependent_package.id
      unless @settings.exists?(package: c.dependent_package)
        @endpoint.notify :add_package, c.dependent_package
      end
    end

    # Auto cleaning unused components
    @settings.where(package: { package_type: :component })
      .where.not(package: components).map do |s|
      @endpoint.notify :remove_package, s
    end

    # Only updated packages
    @settings.joins(:sources).where(Source.arel_table[:created_at].gt(@timestamp)).uniq
  end
end
