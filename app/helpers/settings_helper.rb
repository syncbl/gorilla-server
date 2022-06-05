module SettingsHelper
  def packages_from_params
    (case package_params[:packages].class
    when Array
      package_params[:packages]
    when String
      package_params[:packages].split(",")
    else
      []
    end).grep(UUID_FORMAT)
  end

  def install_package(endpoint, packages)
    return [] unless packages.any?

    settings = Set[]
    Package.where(id: packages.uniq).each do |uuid|
      package = authorize! :show, Package.find_by(id: uuid)
      settings << PackageInstallService.call(endpoint, package)
    end
    settings
  end
end
