class SettingResponse < Response
  def index_valid(package)
    {
      response_type: "settings",
      response: [
        {
          package: short_package(package),
        },
      ],
    }
  end

  def show_valid(package, component)
    {
      response_type: "setting",
      response: {
        active: true,
        package: short_package(package),
        params: {
          path: "TEST1",
          root: "system_root",
        },
        required_components: [
          short_package(component),
        ],
        sources: [
          package_source(package.sources.first),
        ],
      },
    }
  end

  def post_valid(component1, component2)
    {
      response_type: "settings",
      response: [
        {
          active: true,
          package: short_package(component1),
          params: {
            path: "TEST1",
          },
          sources: [],
          required_components: [
            short_package(component2),
          ],
        },
        {
          active: true,
          package: short_package(component2),
          params: {
            path: "TEST1",
          },
          sources: [],
        },
      ],
    }
  end

  private

  # TODO: Move package, source and file to corresponding modules.
  def short_package(package)
    {
      caption: package.caption,
      category: nil,
      h_size: nil,
      id: package.id,
      name: package.relative_name,
      package_type: package.package_type.to_s,
      short_description: package.short_description,
      size: package.size,
      version: package.sources.last&.version,
    }
  end

  # TODO: file, files?
  def package_source(source)
    {
      ancestor: nil,
      caption: source.caption,
      created_at: source.created_at.to_i,
      delete_files: [],
      description: source.description,
      file: source_file(:source, source.file),
      files: source.files,
      h_size: ActionController::Base.helpers.number_to_human_size(source.unpacked_size),
      id: source.id,
      partial: source.partial,
      size: source.unpacked_size,
      updated_at: source.updated_at.to_i,
      version: source.version,
    }
  end

  def source_file(type, file)
    {
      checksum: file.checksum,
      filename: file.filename.to_s,
      type: type.to_s,
      h_size: ActionController::Base.helpers.number_to_human_size(file.byte_size),
      size: file.byte_size,
      url: Rails.application.routes.url_helpers.url_for(file).remove("http://"),
    }
  end
end
