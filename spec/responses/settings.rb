module Responses
  module Settings
    module_function

    def index_valid(package)
      {
        response_type: "settings",
        response: [
          {
            package: {
              caption: package.caption,
              category: nil,
              h_size: nil,
              id: package.id,
              name: package.relative_name,
              package_type: package.package_type.to_s,
              short_description: package.short_description,
              size: package.size,
              version: package.sources.last&.version,
            },
          },
        ],
      }.with_indifferent_access
    end

    def show_valid(package, component)
      {
        response_type: "setting",
        response: {
          active: true,
          package: {
            caption: package.caption,
            category: package.category,
            h_size: nil,
            id: package.id,
            name: package.relative_name,
            package_type: package.package_type.to_s,
            short_description: package.short_description,
            size: 0,
            version: package.sources.last&.version,
          },
          params: {
            path: "TEST1",
            root: "system_root",
          },
          required_components: [
            {
              caption: component.caption,
              category: component.category,
              h_size: nil,
              id: component.id,
              name: component.relative_name,
              package_type: component.package_type.to_s,
              short_description: component.short_description,
              size: 0,
              version: nil,
            },
          ],
          sources: [
            {
              ancestor: nil,
              caption: package.sources.first.caption,
              created_at: package.sources.first.created_at.to_i,
              delete_files: [],
              description: package.sources.first.description,
              file: {
                checksum: package.sources.first.file.checksum,
                filename: "#{package.name}.#{package.sources.first.file.filename}",
                h_size: ActionController::Base.helpers.number_to_human_size(package.sources.first.file.byte_size),
                size: package.sources.first.file.byte_size,
                url: Rails.application.routes.url_helpers.url_for(package.sources.first.file).remove("http://"),
              },
              files: package.sources.first.files,
              h_size: ActionController::Base.helpers.number_to_human_size(package.sources.first.unpacked_size),
              id: package.sources.first.id,
              partial: package.sources.first.partial,
              size: package.sources.first.unpacked_size,
              updated_at: package.sources.first.updated_at.to_i,
              version: package.sources.first.version,
            },
          ],
        },
      }.with_indifferent_access
    end

    def post_valid(component1, component2)
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
              name: component1.relative_name,
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
                name: component2.relative_name,
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
              name: component2.relative_name,
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
      }.with_indifferent_access
    end
  end
end
