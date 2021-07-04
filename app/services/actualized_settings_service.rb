class ActualizedSettingsService < ApplicationService
  def initialize(settings)
    @settings = settings
    #@user = @settings.first&.endpoint.user
  end

  def call
    components = Set[]
    @settings.joins([:package]).map do |s|
      next if components.include?(s.package.id)
      s.package.get_components.each do |c|
        next if components.include?(c.dependent_package.id)
        components << c.dependent_package.id
        unless c.is_optional || @settings.exists?(package: c.dependent_package)
          @settings.create(package: c.component)
        end
      end
    end

    # Auto cleaning unused components
    @settings.joins([:package]).where(package: { is_component: true })
      .where.not(package: components).map(&:destroy)

    @settings
  end
end
