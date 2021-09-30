class ActualizedSettingsService < ApplicationService
  def initialize(endpoint, timestamp)
    @endpoint = endpoint
    @settings = endpoint.settings
    @timestamp = timestamp ? Time.at(timestamp.to_i) : Time.at(0)
  end

  def call
    components = Set[]
    @settings.map do |s|
      next if components.include?(s.package.id)
      Dependency.extract(s.package).map do |c|
        next unless c.required_component? || c.required_package?
        next if components.include?(c.dependent_package.id)
        components << c.dependent_package.id
        unless c.is_optional || @settings.exists?(package: c.dependent_package)
          @endpoint.notify :add_package, c.dependent_package
        end
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
