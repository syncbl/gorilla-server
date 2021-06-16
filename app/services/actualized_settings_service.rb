class ActualizedSettingsService < ApplicationService
  def initialize(settings)
    @settings = settings
    #@user = @settings.first&.endpoint.user
  end

  def call
    # Components can sync silently, but replace can by only with notification

    components = Set[]
    @settings.joins([:package]).map do |s|
      if s.replaced?
        s.endpoint.notify :replace, s
      else
        s.package.get_components.each do |c|
          components << c.component.id
          unless c.is_optional || @settings.exists?(package: c.component)
            @settings.create(package: c.component)
          end
        end
      end
    end

    # Auto cleaning unused components
    @settings.joins([:package]).where(package: { is_component: true }).map do |s|
      s.destroy unless components.include?(s.package.id)
    end

    @settings
  end
end
