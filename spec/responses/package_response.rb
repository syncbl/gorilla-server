class PackageResponse
  include ResponseHelper

  private

  def show_valid(package)
    {
      response_type: "package",
      response: {
        caption: package.caption,
        category: package.category,
        created_at: package.created_at.to_i,
        dependencies: [],
        description: package.description,
        h_install_count: "0",
        h_size: nil,
        icon: nil,
        id: package.id,
        install_count: 0,
        name: "#{package.user.name}/#{package.name}",
        package_type: package.package_type.to_s,
        short_description: package.short_description,
        size: 0,
        updated_at: package.reload.updated_at.to_i,
        user: {
          fullname: package.user.fullname,
          id: package.user.id,
          name: package.user.name,
        },
        version: package.sources.last&.version,
      },
    }
  end
end
