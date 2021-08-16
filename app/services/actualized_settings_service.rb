class ActualizedSettingsService < ApplicationService
  def initialize(settings, timestamp = 0)
    @settings = settings
    @timestamp = Time.at(timestamp) # TODO: Time.zone.at ???
    #@user = @settings.first&.endpoint.user
  end

  def call
    components = Set[]
    @settings.map do |s|
      next if components.include?(s.package.id)
      s.package.get_components.map do |c|
        next if components.include?(c.dependent_package.id)
        components << c.dependent_package.id
        unless c.is_optional || @settings.exists?(package: c.dependent_package)
          @settings.create(package: c.dependent_package)
        end
      end
    end

    # Auto cleaning unused components
    @settings.where(package: { is_component: true })
      .where.not(package: components).map(&:destroy)

    # Only updated packages  
    @settings.select { |s| s.package.updated_at > timestamp }
  end
end
