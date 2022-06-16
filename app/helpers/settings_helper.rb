module SettingsHelper
  # TODO: Inderstand when 403 and when 404

  def packages_from_params
    ids = case package_params
      when Array
        package_params
      when String
        package_params.split(",")
      else
        []
      end

    packages = Set[]
    ids.each do |package|
      packages << if package.include?("/")
        Package.includes(:user)
               .where(user: { name: package.split("/").first })
               .find_by!(name: package.split("/").last).id
      elsif package.match? UUID_FORMAT
        Package.includes(:user)
               .find(package)
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    packages
  end

  def install_packages(endpoint, packages)
    return [] unless packages.any?

    settings = Set[]
    Setting.transaction do
      packages.each do |package|
        # TODO: Consider to use this authorization within a model
        authorize! :show, package
        settings << PackageInstallService.call(endpoint, package)
      end
    rescue ActiveRecord::RecordInvalid
      settings.clear
      raise ActiveRecord::Rollback
    end
    settings
  end
end
