class ActualizedSettingsService < ApplicationService
  def initialize(endpoint, timestamp)
    @endpoint = endpoint
    @settings = endpoint.settings
    @timestamp = timestamp ? Time.at(timestamp.to_i) : Time.at(0)
  end

  # TODO: Notify of new installs instead of that.
  def call
    components = Set[]
    @settings.map do |s|
      next if components.include?(s.package.id)
      Dependency.extract(s.package).map do |c|
        next unless c.required_component? || c.required_package?
        next if components.include?(c.dependent_package.id)
        components << c.dependent_package.id
        unless c.is_optional || @settings.exists?(package: c.dependent_package)
          # @settings.create(package: c.dependent_package)
          @endpoint.notify_object :add_package, c.dependent_package
        end
      end
    end

    # Auto cleaning unused components
    @settings.where(package: { package_type: :component })
      .where.not(package: components).map do |s|
        @endpoint.notify_object :remove_package, s 
    end

    # Only updated packages
    settings = @settings.joins(:sources).where(Source.arel_table[:created_at].gt(@timestamp)).uniq

    return settings
  end
end
