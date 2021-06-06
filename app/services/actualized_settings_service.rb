class ActualizedSettingsService < ApplicationService
  def initialize(settings)
    @settings = settings
    #@user = @settings.first&.endpoint.user
  end

  def call
    # TODO: Remove old components
    components = Set[]
    @settings.joins([:package]).map do |s|
      if s.replaced?
        s.update(package: s.package.replaced_by)
        s.package.replaced_by.get_components.each do |c|
          components << c.id
          unless @settings.exists?(package: c) || c.is_optional
            @settings.create(package: c)
          end
        end
      else
        s.package.get_components.each do |c|
          components << c.id
          unless @settings.exists?(package: c) || c.is_optional
            @settings.create(package: c)
          end
        end
      end
    end

    @settings.joins([:package]).where(package: { is_component: true }).map do |s|
      s.destroy unless components.include?(s.package.id)
    end

    @settings
  end
end
