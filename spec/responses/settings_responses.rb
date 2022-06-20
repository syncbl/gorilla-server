module SettingsResponses
  module_function

  def short_response(package)
    {
      response_type: "settings",
      response: [
        {
          package: {
            caption: package.caption,
            category: nil,
            h_size: nil,
            id: package.id,
            name: "#{package.user.name}/#{package.name}",
            package_type: package.package_type.to_s,
            short_description: package.short_description,
            size: package.size,
            version: package.sources.last&.version,
          },
        },
      ],
    }
  end

  def long_response(component1, component2)
    {
      response_type: "settings",
      response: [
        {
          active: true,
          package: {
            caption: component1.caption,
            category: component1.category,
            h_size: nil,
            id: component1.id,
            name: "#{component1.user.name}/#{component1.name}",
            package_type: component1.package_type.to_s,
            short_description: component1.short_description,
            size: 0,
            version: nil,
          },
          params: {
            path: "TEST1",
          },
          sources: [],
          required_components: [
            {
              caption: component2.caption,
              category: component2.category,
              h_size: nil,
              id: component2.id,
              name: "#{component2.user.name}/#{component2.name}",
              package_type: component2.package_type.to_s,
              short_description: component2.short_description,
              size: 0,
              version: nil,
            },
          ],
        },
        {
          active: true,
          package: {
            caption: component2.caption,
            category: component2.category,
            h_size: nil,
            id: component2.id,
            name: "#{component2.user.name}/#{component2.name}",
            package_type: component2.package_type.to_s,
            short_description: component2.short_description,
            size: 0,
            version: nil,
          },
          params: {
            path: "TEST1",
          },
          sources: [],
        },
      ],
    }
  end

  def component_error_response
    {
      errors: {
        packages: ["Validation failed: Package Can't install component without corresponding bundle"],
      },
    }
  end
end
